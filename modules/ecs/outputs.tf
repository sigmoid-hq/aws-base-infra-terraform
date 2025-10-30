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


output "cluster_id" {
  description = "Identifier of the ECS cluster."
  value       = aws_ecs_cluster.main.id
}

output "cluster_arn" {
  description = "ARN of the ECS cluster."
  value       = aws_ecs_cluster.main.arn
}

output "service_name" {
  description = "Name of the ECS service."
  value       = aws_ecs_service.app.name
}

output "service_security_group_id" {
  description = "Security group protecting the ECS tasks."
  value       = aws_security_group.service.id
}

output "alb_arn" {
  description = "ARN of the application load balancer."
  value       = aws_lb.main.arn
}

output "alb_dns_name" {
  description = "Public DNS name of the application load balancer."
  value       = aws_lb.main.dns_name
}

output "target_group_arn" {
  description = "ARN of the target group serving the API."
  value       = aws_lb_target_group.app.arn
}

output "task_definition_arn" {
  description = "ARN of the active task definition."
  value       = aws_ecs_task_definition.app.arn
}

output "log_group_name" {
  description = "CloudWatch log group capturing application logs."
  value       = aws_cloudwatch_log_group.app.name
}
