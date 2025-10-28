output "vpc_id" {
  description = "Identifier of the VPC created by this module."
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block associated with the VPC."
  value       = aws_vpc.main.cidr_block
}

output "availability_zones" {
  description = "Availability zones used for subnet placement."
  value       = data.aws_availability_zones.available.names
}

output "public_subnet_ids" {
  description = "Identifiers for the public subnets."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Identifiers for the private subnets."
  value       = aws_subnet.private[*].id
}

output "public_route_table_id" {
  description = "Identifier for the shared public route table."
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "Identifiers for the private route tables."
  value       = aws_route_table.private[*].id
}

output "internet_gateway_id" {
  description = "Identifier for the Internet Gateway attached to the VPC."
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_ids" {
  description = "Identifiers for the NAT Gateways created per availability zone."
  value       = aws_nat_gateway.main[*].id
}

output "nat_eip_ids" {
  description = "Elastic IP identifiers associated with the NAT Gateways."
  value       = aws_eip.nat[*].id
}
