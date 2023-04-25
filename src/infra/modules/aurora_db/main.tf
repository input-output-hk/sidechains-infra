module "label" {
  # v0.25.0
  source = "github.com/cloudposse/terraform-null-label?ref=488ab91e34a24a86957e397d9f7262ec5925586a"

  namespace   = var.label.namespace
  environment = var.label.environment
  stage       = var.label.stage
  name        = "database-cluster"
  attributes  = var.label.attributes
  delimiter   = var.label.delimiter
  tags        = var.label.tags
}

data "aws_vpc" "this" {
  id = var.vpc_id
}

module "security_group" {
  # v4.16.2
  source = "github.com/terraform-aws-modules/terraform-aws-security-group?ref=700f32c275e2367a766f4c2824d31d7669a91a00"

  name        = "RDSAccessForVPC"
  description = "Allows access to RDS instance from within VPC"
  vpc_id      = data.aws_vpc.this.id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = var.port
      to_port     = var.port
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = data.aws_vpc.this.cidr_block
    },
    {
      from_port   = var.port
      to_port     = var.port
      protocol    = "tcp"
      description = "PostgreSQL access from Nomad clients"
      cidr_blocks = "10.0.0.0/8"
    },
  ]

  tags = module.label.tags
}

resource "random_password" "this" {
  length  = 16
  special = false
}

data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
}

module "db" {
  # v.1.3.2
  source = "github.com/cloudposse/terraform-aws-rds-cluster?ref=3d2e16a693c8e88d55532f86d82b6f2eb6df3be1"

  engine         = var.engine
  engine_version = var.engine_version
  cluster_family = var.cluster_family
  # 1 writer, 2 reader
  cluster_size   = 3
  namespace      = var.label.namespace
  stage          = var.label.stage
  admin_user     = var.username
  admin_password = random_password.this.result
  db_name        = "${var.label.environment}DB"
  db_port        = var.port
  instance_type  = "db.serverless"
  vpc_id         = data.aws_vpc.this.id
  subnets        = data.aws_subnets.this.ids
  # db_subnet_group_name   = var.vpc_subnet_group
  vpc_security_group_ids = [module.security_group.security_group_id]
  serverlessv2_scaling_configuration = {
    max_capacity = 9
    min_capacity = 3
  }
  rds_monitoring_interval               = 30
  rds_monitoring_role_arn               = aws_iam_role.enhanced_monitoring.arn
  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  performance_insights_kms_key_id       = "arn:aws:kms:eu-central-1:305415268059:key/591346d7-48c5-4943-9166-13f90bb40c67"
  tags                                  = module.label.tags
}

# create IAM role for monitoring
resource "aws_iam_role" "enhanced_monitoring" {
  name               = "rds-cluster-example-1"
  assume_role_policy = data.aws_iam_policy_document.enhanced_monitoring.json
}

# Attach Amazon's managed policy for RDS enhanced monitoring
resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
  role       = aws_iam_role.enhanced_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# allow rds to assume this role
data "aws_iam_policy_document" "enhanced_monitoring" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "consul_node" "db-write" {
  name    = "db-write"
  address = module.db.endpoint

  meta = {
    "external-node"  = "true"
    "external-probe" = "true"
  }
}

resource "consul_node" "db-read" {
  name    = "db-read"
  address = module.db.reader_endpoint

  meta = {
    "external-node"  = "true"
    "external-probe" = "true"
  }
}

resource "consul_service" "write-db" {
  name    = "write-db"
  address = module.db.endpoint
  port    = var.port
  node    = consul_node.db-write.name
}

resource "consul_service" "read-db" {
  name    = "read-db"
  address = module.db.reader_endpoint
  port    = var.port
  node    = consul_node.db-read.name
}

resource "aws_secretsmanager_secret" "this" {
  name                    = "${module.label.environment}/db/root_account"
  recovery_window_in_days = 0

  tags = module.label.tags
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id = aws_secretsmanager_secret.this.id
  secret_string = jsonencode({
    username = module.db.master_username
    password = random_password.this.result
    port     = var.port
    host     = module.db.endpoint
  })
}

resource "aws_iam_policy" "this" {
  for_each    = var.permissions
  name        = "${module.label.id}-${each.key}-permissions"
  description = "Permissions for ${each.key} group access to ${module.label.id} root secret"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = var.policy_templates.secrets[each.value.policy]
        Effect   = "Allow"
        Resource = aws_secretsmanager_secret.this.arn
      },
    ]
  })

  tags = module.label.tags
}
