## Create ECR repositories for publishing images ##
resource "aws_ecr_repository" "ci" {
  for_each             = toset(var.ecr_repos)
  name                 = each.key
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_lifecycle_policy" "ci-policy" {
  for_each   = toset(var.ecr_repos)
  repository = aws_ecr_repository.ci[each.key].name
  policy     = <<EOF
{
    "rules": [
        {
            "rulePriority": 10,
            "description": "Keep Stable Images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["v"],
                "countType": "imageCountMoreThan",
                "countNumber": 99999
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 20,
            "description": "Delete Old Unstable Images",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 60
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}