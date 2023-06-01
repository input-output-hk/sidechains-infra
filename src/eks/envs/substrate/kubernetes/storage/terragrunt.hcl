include "root" {
  path = find_in_parent_folders()
}

include "network" {
  path = "${get_repo_root()}/src/eks/deps/network.hcl"
}

include "common" {
  path   = find_in_parent_folders("common.hcl")
  expose = true
}

include "kubernetes" {
  path = "${get_repo_root()}/src/eks/deps/kubernetes/cluster.hcl"
}

terraform {
  # See: https://github.com/gruntwork-io/terragrunt/issues/1675
  source = "${get_repo_root()}/src/eks/modules/storage//."
}

inputs = {
  role_name = "efs-storage-csi"
  account   = include.common.locals.account
  region    = include.common.locals.region
}