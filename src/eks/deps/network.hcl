locals {
  env  = split("/", split("envs/", path_relative_to_include())[1])[0]
  root = get_repo_root()
}

dependency "network" {
  config_path = "${local.root}/src/eks/envs/${local.env}/network"

  mock_outputs = {
    vpc                   = {}
    vpc_id                = "mock-id"
    vpc_cidr_block        = "mock-cidr"
    private_subnets       = []
    public_subnets        = []
    database_subnet_group = "mock-subnet-group"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate"]
}