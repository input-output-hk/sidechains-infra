include "root" {
  path = find_in_parent_folders()
}

include "network" {
  path = "${get_repo_root()}/src/eks/deps/network.hcl"
}

terraform {
  # See: https://github.com/gruntwork-io/terragrunt/issues/1675
  source = "git@github.com:input-output-hk/catalyst-tf.git//modules/kubernetes/cluster?ref=v1.1.0"
}

inputs = {
  cluster_version = "1.25"

  cluster_desired_size = 8
  cluster_min_size     = 1
  cluser_max_size      = 8

  node_disk_size = "200"
  instance_types = ["t2.2xlarge", "t3.2xlarge"]

  vpc_id     = dependency.network.outputs.vpc_id
  subnet_ids = dependency.network.outputs.private_subnets
}