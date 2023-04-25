module "label" {
  # v0.25.0
  source = "github.com/cloudposse/terraform-null-label?ref=488ab91e34a24a86957e397d9f7262ec5925586a"

  namespace   = var.label.namespace
  environment = var.label.environment
  stage       = var.label.stage
  name        = var.label.name
  attributes  = var.label.attributes
  delimiter   = var.label.delimiter
  tags        = var.label.tags
}

module "groups" {
  for_each = var.groups
  source   = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"

  name = each.key

  group_users = each.value.users

  attach_iam_self_management_policy = true

  custom_group_policy_arns = each.value.policy_arns

  custom_group_policies = [for name, policy in each.value.policies : {
    name   = name
    policy = policy
  }]

  tags = module.label.tags
}

resource "aws_iam_user" "this" {
  for_each = var.users
  name     = each.key
  tags     = module.label.tags
}

resource "aws_iam_user_login_profile" "this" {
  for_each                = var.users
  user                    = each.key
  pgp_key                 = each.value.pgp_key
  password_reset_required = true

  # In cases where an existing user is imported, don't recreate this resource
  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key,
    ]
  }

  depends_on = [
    aws_iam_user.this
  ]
}

resource "aws_iam_policy" "this" {
  name        = "global-common-permissions"
  description = "Common permissions shared by all IAM entities"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = var.common_policies
  })

  tags = module.label.tags
}

resource "aws_iam_group_policy_attachment" "this" {
  for_each   = var.groups
  group      = each.key
  policy_arn = aws_iam_policy.this.arn
}
