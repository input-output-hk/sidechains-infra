locals {
  # Used as tags to uniquely identify resources created by this repository
  namespace   = "iog"
  environment = "mamba"

  # Common AWS parameters
  account = "305415268059"
  region  = "eu-central-1"

  # Configuration details for remote S3 state
  state = {
    region = "eu-central-1"
    bucket = "iog-mamba-infra"
    lock   = "iog-mamba-infra-lock"
  }

  # The groups we use for permissions
  groups = [
    "developer",
    "qa",
    "sre",
  ]

  # The services we deploy
  services = [
    "app",
    "core",
  ]

  # Common policy definitions used across modules for permissions
  policy_templates = {
    s3 = {
      read = [
        "s3:Get*",
        "s3:List*",
      ]
      readwrite = [
        "s3:Get*",
        "s3:List*",
        "s3:Put*",
      ]
      super = [
        "s3:*",
      ]
    }

    secrets = {
      read = [
        "secretsmanager:Describe*",
        "secretsmanager:GetSecretValue",
      ]
      readwrite = [
        "secretsmanager:Describe*",
        "secretsmanager:GetSecretValue",
        "secretsmanager:PutSecretValue",
      ]
      super = [
        "secretsmanager:*",
      ]
    }
  }
}