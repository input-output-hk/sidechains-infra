resource "vault_jwt_auth_backend" "ci" {
  description        = "JWT auth backend for GitHub CI"
  oidc_discovery_url = "https://token.actions.githubusercontent.com"
  bound_issuer       = "https://token.actions.githubusercontent.com"
}

resource "vault_jwt_auth_backend_role" "ci" {
  backend        = vault_jwt_auth_backend.ci.path
  role_name      = "github-ci"
  token_policies = [vault_policy.ci.name]

  bound_audiences   = ["https://github.com/input-output-hk"]
  bound_claims_type = "glob"
  bound_claims = {
    sub = join(",", [for repo in var.authorized_vault_repos : "repo:${repo}:*"])
  }
  user_claim = "job_workflow_ref"
  role_type  = "jwt"
}

resource "vault_policy" "ci" {
  name = "github-ci"

  # FIXME: define a specific nomad role for CI
  policy = <<EOT
path "nomad/creds/developer" {
  capabilities = ["read", "list"]
}

path "consul/creds/developer" {
  capabilities = ["read", "list"]
}

path "auth/token/create" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "kv/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "aws/roles/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "sops/*" {
  capabilities = ["read", "update", "list"]
}
EOT
}

resource "aws_iam_role_policy_attachment" "ci_iam_access" {
  role       = aws_iam_role.ci.name
  policy_arn = aws_iam_policy.ci_iam_access.arn
}

resource "aws_iam_policy" "ci_iam_access" {
  name        = "CIIAMAccess"
  description = "Provides access to manage IAM groups"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iam:GetGroup",
          "iam:GetGroupPolicy",
        ]
        Effect = "Allow"
        Resource = [
          "*"
        ]
      },
    ]
  })
}
