include "root" {
  path = find_in_parent_folders()
}

terraform {
  # See: https://github.com/gruntwork-io/terragrunt/issues/1675
  source = "${get_repo_root()}/src/infra/modules/ci//."
}

inputs = {
  authorized_aws_repos = [
    "input-output-hk/mamba-world",
    "input-output-hk/sidechains-bridge-backend"
  ]
  authorized_vault_repos = [
    "input-output-hk/mamba-world"
  ]
  iam_user = "mamba-world-ci"
  iam_role = "mamba-world-ci"
  ecr_repos = [
    "mamba",
    "mamba-faucet",
    "mamba-relay",
    "mamba-observer",
    "mamba-public-documentation",
    "db-sync",
    "ogmios",
    "ogmios-datum-cache",
    "ctl-server",
    "blockscout",
    "bridge-backend",
    "bridge-backend-world",
    "kupo",
    "marconi",
  ]
}
