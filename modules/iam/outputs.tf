output "poweruser_role_name" {
  description = "Name of the PowerUser IAM role."
  value       = aws_iam_role.poweruser.name
}

output "poweruser_role_arn" {
  description = "ARN of the PowerUser IAM role."
  value       = aws_iam_role.poweruser.arn
}

output "poweruser_instance_profile_name" {
  description = "Name of the PowerUser IAM instance profile."
  value       = aws_iam_instance_profile.poweruser.name
}

output "poweruser_instance_profile_arn" {
  description = "ARN of the PowerUser IAM instance profile."
  value       = aws_iam_instance_profile.poweruser.arn
}

output "readonly_role_name" {
  description = "Name of the ReadOnly IAM role."
  value       = aws_iam_role.readonly.name
}

output "readonly_role_arn" {
  description = "ARN of the ReadOnly IAM role."
  value       = aws_iam_role.readonly.arn
}

output "readonly_instance_profile_name" {
  description = "Name of the ReadOnly IAM instance profile."
  value       = aws_iam_instance_profile.readonly.name
}

output "readonly_instance_profile_arn" {
  description = "ARN of the ReadOnly IAM instance profile."
  value       = aws_iam_instance_profile.readonly.arn
}

output "ecs_task_execution_role_name" {
  description = "Name of the ECS Task Execution IAM role."
  value       = aws_iam_role.ecs_task_execution_role.name
}

output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS Task Execution IAM role."
  value       = aws_iam_role.ecs_task_execution_role.arn
}
