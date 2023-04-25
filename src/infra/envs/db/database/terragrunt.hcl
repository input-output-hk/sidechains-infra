locals {
  blockscout_extensions = ["btree_gist", "pg_trgm", "citext"]
}
include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path   = "${get_repo_root()}/src/infra/common.hcl"
  expose = true
}

include "aurora_db" {
  path = "${get_repo_root()}/src/infra/deps/aurora_db.hcl"
}

terraform {
  # See: https://github.com/gruntwork-io/terragrunt/issues/1675
  source = "${get_repo_root()}/src/infra/modules/database//."
}

inputs = {
  databases = [
    { name = "ogmios", count = 3 },
    { name = "db-sync" },
    { name = "blockscout_atago", extensions = local.blockscout_extensions },
    { name = "blockscout_staging", extensions = local.blockscout_extensions },
    { name = "blockscout_unzen", extensions = local.blockscout_extensions },
  ]
  db_cluster_id = dependency.aurora_db.outputs.id
  environment   = split("/", split("envs/", path_relative_to_include("root"))[1])[0]

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