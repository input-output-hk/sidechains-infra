locals {
  env    = split("/", split("envs/", path_relative_to_include())[1])[0]
  db_env = "db"
  root   = get_repo_root()
}

dependency "aurora_db" {
  config_path = "${local.root}/src/infra/envs/${local.db_env}/aurora_db"

  mock_outputs = {
    id              = "mock-id"
    endpoint        = "mock-endpoint"
    reader_endpoint = "mock-reader"
    user            = "mock-user"
    password        = "mock-password"
    secret_arn      = "mock-arn"
    policies = {
      developer = {
        policy = "mock-policy"
      }
      qa = {
        policy = "mock-policy"
      }
      sre = {
        policy = "mock-policy"
      }
    }
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate"]
}

generate "db_versions" {
  path      = "db_versions.tf"
  if_exists = "overwrite"
  contents  = <<EOF
    terraform {
      required_providers {
        postgresql = {
          source = "cyrilgdn/postgresql"
          version = "1.18.0"
        }
        vault = {
          source = "hashicorp/vault"
          version = "3.13.0"
        }
      }
    }
EOF
}

generate "provider_db" {
  path      = "provider_db.tf"
  if_exists = "overwrite"
  contents  = <<EOF
locals {
    creds = jsondecode(data.aws_secretsmanager_secret_version.this.secret_string)
}

# Don't rely on state data for credentials as they may be subject to rotation
data "aws_secretsmanager_secret_version" "this" {
  secret_id = "${dependency.aurora_db.outputs.secret_arn}"
}

provider "postgresql" {
  # FIXME: find some way to automatically get a connection to the database without making it public
  # for now, use `ssh -L` to forward a port from one of the machines in the network, such as the deployer
  # host     = local.creds.host
  host     = "localhost"
  username = local.creds.username
  port     = local.creds.port
  password = local.creds.password

  superuser = false
}
EOF
}