output "instance_identifier" {
  description = "Identifier of the RDS instance."
  value       = aws_db_instance.main.id
}

output "endpoint" {
  description = "Connection endpoint for the RDS instance."
  value       = aws_db_instance.main.endpoint
}

output "port" {
  description = "Port exposed by the RDS instance."
  value       = aws_db_instance.main.port
}

output "security_group_id" {
  description = "Identifier of the security group protecting the RDS instance."
  value       = aws_security_group.main.id
}

output "subnet_group_name" {
  description = "Name of the subnet group associated with the RDS instance."
  value       = aws_db_subnet_group.main.name
}
