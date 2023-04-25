output "id" {
  description = "The RDS Aurora Cluster ID"
  value       = module.db.cluster_identifier
}

output "endpoint" {
  description = "The connection endpoint"
  value       = module.db.endpoint
}

output "port" {
  description = "The port number the database is listening on"
  value       = var.port
}

output "reader_endpoint" {
  description = "A read-only endpoint for the Aurora cluster, automatically load-balanced across replicas"
  value       = module.db.reader_endpoint
}

output "user" {
  description = "The master username for the database"
  value       = module.db.master_username
  sensitive   = true
}

output "password" {
  description = "The master password for the database"
  value       = random_password.this.result
  sensitive   = true
}

output "secret_arn" {
  description = "The ARN of the secret containing root connection details"
  value       = aws_secretsmanager_secret.this.arn
}

output "policies" {
  description = "The configured group policies for access to cluster root credentials"
  value       = aws_iam_policy.this
}
