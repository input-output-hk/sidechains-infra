################################################################################
# To add yourself:
#  1. Add your username under `users`
#  2. Run `gpg --export [key_id] | base64` replacing `key_id` with your PGP key id
#  3. Paste the result into the `pgp_key` attribute underneath your username
#  4. Add your username to the appropriate group under `groups`
#  5. Submit a PR
################################################################################
locals {
  users = {
    "const-iohk" = {
      pgp_key = ""
    },
    "nrdxp" = {
      pgp_key = "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"
    },
    "skylar-simoncelli" = {
      pgp_key = "mDMEZBnUjxYJKwYBBAHaRw8BAQdA3hkM7uOAGZMn4dLBPBpEdM2EzA9ksPFDQ7w/mwrCPTO0IGlvaGsgPHNreWxhci5zaW1vbmNlbGxpQGlvaGsuaW8+iHcEEBYKAB8FAmQZ1I8GCwkHCAMCBBUICgIDFgIBAhkBAhsDAh4BAAoJEMJ7+PbAGrKltfABAI04NOvwuItgpq+wObovM2X3gBA51RfFnkR7M5bXgaKvAQDCCGli8EBSGsPFXjl6MO8lzSoOtoe6W9TkFMXlJunpDbg4BGQZ1I8SCisGAQQBl1UBBQEBB0CJwMHc/dbgSBZoSRSkSN81DBI5JQ8tDOEYR5Z/I8QbbwMBCAeIYQQYFggACQUCZBnUjwIbDAAKCRDCe/j2wBqypQEoAQD258/sTTx+UaSCkegbcXV138BuE5DDi1iMEJ1VXms1AwD9G1RXo0N/i9ZxzDW+A/pFv3SLeicj531GLS9KWfu4fgM="
    }
  }

  groups = {
    developer = []
    qa = []
    sre = [
      "const-iohk",
      "nrdxp",
      "skylar-simoncelli",
    ]
  }

  account = include.common.locals.account
  region = include.common.locals.region
  bucket = include.common.locals.state.bucket
  lock = include.common.locals.state.lock
  common = [
    {
      Effect = "Allow"
      Action = [
        "dynamodb:DescribeTable"
      ]
      Resource = "arn:aws:dynamodb:${local.region}:${local.account}:table/${local.lock}"
    },
    {
        Effect = "Allow"
        Action = [
            "eks:ListClusters"
        ]
        Resource = "*"
    },
    {
      Effect = "Allow"
      Action = [
        "s3:ListAllMyBuckets"
      ]
      Resource = "*"
    },
    {
        Effect = "Allow"
        Action = [
          "s3:Get*",
          "s3:List*"
        ]
        Resource = [
          "arn:aws:s3:::${local.bucket}",
        ]
      }
  ]
}

include "root" {
  path = find_in_parent_folders()
}

include "common" {
    path = find_in_parent_folders("common.hcl")
    expose = true
}

terraform {
    source = "git@github.com:input-output-hk/catalyst-tf.git//modules/idm?ref=v1.0.0"
}

inputs = {
  groups = {
    developer = {
      users = local.groups.developer
      policy_arns = []
      policies = {}
    }

    qa = {
      users = local.groups.qa
      policy_arns = []
      policies = {}
    }

    sre = {
      users = local.groups.sre
      policy_arns = [
        "arn:aws:iam::aws:policy/AdministratorAccess",
      ]
      policies = []
    }
  }
  common_policies = local.common
  users = local.users
}
