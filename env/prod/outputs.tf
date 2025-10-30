output "vpc_id" {
  description = "Identifier for the production VPC."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet identifiers in the production VPC."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet identifiers in the production VPC."
  value       = module.vpc.private_subnet_ids
}

output "rds_endpoint" {
  description = "Endpoint address for the production database."
  value       = module.rds.endpoint
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table used in production."
  value       = module.dynamodb.table_name
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table used in production."
  value       = module.dynamodb.table_arn
}

output "ecs_service_name" {
  description = "Name of the ECS service running production workloads."
  value       = module.ecs.service_name
}

output "ecs_alb_dns_name" {
  description = "DNS name of the ALB fronting the production ECS service."
  value       = module.ecs.alb_dns_name
}

output "cloudfront_distribution_domain" {
  description = "Domain name of the production CloudFront distribution."
  value       = module.cloudfront.distribution_domain_name
}
