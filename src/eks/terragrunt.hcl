locals {
    # Cannot have nested includes, so we read the config directly
    common = read_terragrunt_config("${get_parent_terragrunt_dir()}/common.hcl").locals
    state = local.common.state
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket = local.state.bucket

    key = "${split("envs/", path_relative_to_include())[1]}/terraform.tfstate"
    region         = local.state.region
    encrypt        = true
    dynamodb_table = local.state.lock
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite"
  contents = <<EOF
provider "aws" {
  region = "${local.state.region}"
}

provider "aws" {
    region = "us-east-1"
    alias = "useast1"
}
EOF
}

inputs = {
    label = {
        namespace = local.common.namespace
        environment = local.common.environment
        stage = split("/", path_relative_to_include())[1]
        name = split("/", path_relative_to_include())[2]
    }
    policy_templates = local.common.policy_templates
}