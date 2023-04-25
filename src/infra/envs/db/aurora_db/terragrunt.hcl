include "root" {
  path = find_in_parent_folders()
}

# include "network" {
#     path = "${get_repo_root()}/src/infra/deps/network.hcl"
# }

terraform {
  # See: https://github.com/gruntwork-io/terragrunt/issues/1675
  source = "${get_repo_root()}/src/infra/modules/aurora_db//."
}

inputs = {
  # HACK: reference to the bitte cluster's core VPC
  vpc_id = "vpc-09cc79794733dea72"
  # vpc_subnet_group = dependency.network.outputs.database_subnet_group
  # vpc_cidr = data.aws_vpc.core.cidr_block

  permissions = {
    developer = {
      policy = "read"
    }
    qa = {
      policy = "read"
    }
    sre = {
      policy = "super"
    }
  }

  environment = split("/", split("envs/", path_relative_to_include("root"))[1])[0]
}