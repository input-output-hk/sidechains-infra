locals {
  # Used as tags to uniquely identify resources created by this repository
  namespace = "iog"
  environment = "sidechain"

  # Common AWS parameters
  account = "689191102645"
  region = "eu-central-1"

  # Configuration details for remote S3 state
  state = read_terragrunt_config("${get_parent_terragrunt_dir()}/state.hcl").locals

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

  # The databases we deploy
  databases = [
    "app",
    "core",
  ]

  # Common policy definitions used across modules for permissions
  policy_templates = {
    eks = {
      read = [
        "eks:AccessKubernetesApi",
        "eks:DescribeCluster",
      ]
      super = [
        "eks:*"
      ]
    }

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