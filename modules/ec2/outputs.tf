output "instance_id" {
  description = "Identifier of the EC2 instance provisioned by the module."
  value       = aws_instance.main.id
}

output "instance_private_ip" {
  description = "Private IPv4 address assigned to the EC2 instance."
  value       = aws_instance.main.private_ip
}

output "instance_public_ip" {
  description = "Public IPv4 address associated with the EC2 instance (null when Elastic IP is not allocated)."
  value       = length(aws_eip.main) > 0 ? aws_eip.main[0].public_ip : aws_instance.main.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name for the EC2 instance."
  value       = aws_instance.main.public_dns
}

output "security_group_id" {
  description = "Identifier of the security group attached to the EC2 instance."
  value       = aws_security_group.main.id
}

output "key_pair_name" {
  description = "Name of the SSH key pair associated with the EC2 instance."
  value       = aws_key_pair.main.key_name
}

output "elastic_ip_allocation_id" {
  description = "Allocation identifier for the Elastic IP when one is provisioned."
  value       = length(aws_eip.main) > 0 ? aws_eip.main[0].id : null
}
