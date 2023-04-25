locals {
  all_dbs = flatten([
    for db in var.databases : [
      for i in range(0, db.count) : {
        name       = db.count == 1 ? db.name : "${db.name}_${i}"
        owner      = db.name
        extensions = db.extensions
      }
    ]
  ])

  all_exts = flatten([
    for db in local.all_dbs : [
      for ext in db.extensions : {
        name = ext
        db   = db.name
      }
    ]
  ])

  owners = toset([for db in var.databases : db.name])
}

module "label" {
  # v0.25.0
  source = "github.com/cloudposse/terraform-null-label?ref=488ab91e34a24a86957e397d9f7262ec5925586a"

  namespace   = var.label.namespace
  environment = var.label.environment
  stage       = var.label.stage
  name        = var.label.name
  attributes  = var.label.attributes
  delimiter   = var.label.delimiter
  tags        = var.label.tags
}

data "aws_rds_cluster" "database" {
  cluster_identifier = var.db_cluster_id
}

resource "random_password" "this" {
  for_each = local.owners
  length   = 16
  special  = false
}

resource "postgresql_role" "this" {
  for_each = local.owners

  name     = each.value
  password = random_password.this[each.value].result

  login = true
}


resource "vault_policy" "this" {
  for_each = local.owners
  name     = "${each.value}-db"

  policy = <<EOT
path "postgres/creds/${each.value}" {
  capabilities = ["read", "list"]
}
path "kv/data/db/${each.value}" {
  capabilities = ["read", "list"]
}
EOT
}

resource "vault_mount" "db" {
  path = "postgres"
  type = "database"
}

resource "vault_database_secret_backend_connection" "postgres" {
  backend           = vault_mount.db.path
  name              = "postgres"
  allowed_roles     = local.owners
  verify_connection = true

  postgresql {
    connection_url = "postgres://{{username}}:{{password}}@${data.aws_rds_cluster.database.endpoint}/postgres"
    username       = local.creds.username
    password       = local.creds.password
  }
}

resource "vault_database_secret_backend_role" "this" {
  for_each = local.owners

  backend     = vault_mount.db.path
  name        = each.value
  db_name     = vault_database_secret_backend_connection.postgres.name
  default_ttl = "3600"
  max_ttl     = "7200"

  depends_on = [postgresql_role.this]

  creation_statements = [
    "CREATE ROLE \"{{name}}\" IN ROLE \"${each.value}\" LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';",
    # switch to permanent role immediately after login so new tables are owned by the permanent role
    # avoiding access issues on those tables for other dynamically generated users
    "ALTER ROLE \"{{name}}\" SET ROLE \"${each.value}\";"
  ]

  # Drop role but leave connections open so jobs can continue with db access until they stop
  # since we switched to the permanent role after login, we will still have full access to read/write
  revocation_statements = [
    "DROP ROLE IF EXISTS \"{{name}}\";",
  ]

  renew_statements = [
    "ALTER ROLE \"{{name}}\" VALID UNTIL '{{expiration}}';",
  ]
}

resource "postgresql_database" "this" {
  for_each = {
    for db in local.all_dbs : db.name => db.owner
  }


  name              = each.key
  owner             = postgresql_role.this[each.value].name
  lc_collate        = "en_US.UTF-8"
  connection_limit  = 1024
  allow_connections = true
}

resource "postgresql_extension" "this" {
  for_each = {
    for ext in local.all_exts : "${ext.name}-${ext.db}" => ext
  }


  depends_on     = [postgresql_database.this]
  name           = each.value.name
  database       = each.value.db
  create_cascade = true
  drop_cascade   = true
}

resource "vault_generic_secret" "this" {
  for_each = postgresql_role.this
  path     = "kv/db/${each.value.name}"
  data_json = jsonencode({
    username = each.value.name
    password = random_password.this[each.value.name].result
  })
}

resource "aws_secretsmanager_secret" "this" {
  for_each = local.owners

  name                    = "${var.environment}/db/${each.value}"
  recovery_window_in_days = 0
  tags                    = module.label.tags
}

resource "aws_secretsmanager_secret_version" "this" {
  for_each = local.owners

  secret_id = aws_secretsmanager_secret.this[each.value].id
  secret_string = jsonencode({
    username = postgresql_role.this[each.value].name
    password = random_password.this[each.value].result
    engine   = data.aws_rds_cluster.database.engine
    host     = split(":", data.aws_rds_cluster.database.endpoint)[0]
    port     = data.aws_rds_cluster.database.port
  })
}

resource "aws_iam_policy" "this" {
  for_each    = var.permissions
  name        = "${module.label.id}-${each.key}-permissions"
  description = "Permissions for ${each.key} group access to ${var.environment} database credentials"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = var.policy_templates.secrets[each.value.policy]
        Effect   = "Allow"
        Resource = [for secret in aws_secretsmanager_secret.this : secret.arn]
      },
    ]
  })

  tags = module.label.tags
}