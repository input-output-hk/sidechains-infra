include "root" {
  path = find_in_parent_folders()
}

include "kubernetes" {
  path = "${get_repo_root()}/src/eks/deps/kubernetes/cluster.hcl"
}

terraform {
  source = "git@github.com:input-output-hk/catalyst-tf.git//modules/kubernetes/access?ref=v1.0.0"
}

inputs = {
  cluster_name     = dependency.kubernetes.outputs.cluster_name
  cluster_node_arn = dependency.kubernetes.outputs.cluster_default_node_group_arn
  auth_map = {
    developer = ["system:masters"]
    qa        = ["system:masters"]
    sre       = ["system:masters"]
  }
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
}