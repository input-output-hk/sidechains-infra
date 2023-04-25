output "secret_arns" {
  description = "The ARNs for all secrets containing database credentials"
  value       = { for name, secret in aws_secretsmanager_secret.this : name => secret.arn }
}

output "policies" {
  description = "The configured group policies for access to core service objects"
  value       = aws_iam_policy.this
}
