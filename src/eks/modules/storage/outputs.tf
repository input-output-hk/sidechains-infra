output "id" {
  description = "The EFS filesystem ID"
  value       = aws_efs_file_system.storage.id
}
