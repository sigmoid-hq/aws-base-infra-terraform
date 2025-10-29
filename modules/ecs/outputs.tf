output "repository_name" {
  description = "Name of the ECR repository provisioned for the application."
  value       = aws_ecr_repository.app.name
}

output "repository_url" {
  description = "Fully qualified URI that can be used to push/pull container images."
  value       = aws_ecr_repository.app.repository_url
}

output "repository_arn" {
  description = "ARN of the ECR repository."
  value       = aws_ecr_repository.app.arn
}
