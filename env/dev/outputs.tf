output "vpc_id" {
  description = "Identifier for the VPC hosting the environment."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet identifiers created by the VPC module."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet identifiers created by the VPC module."
  value       = module.vpc.private_subnet_ids
}

output "static_site_bucket" {
  description = "Regional domain name for the S3 bucket serving the static site."
  value       = module.s3.asset_bucket_regional_domain_name
}

output "rds_endpoint" {
  description = "Endpoint address for the application database."
  value       = module.rds.endpoint
}

output "dynamodb_table_name" {
  description = "Primary DynamoDB table name used by the environment."
  value       = module.dynamodb.table_name
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table backing application state."
  value       = module.dynamodb.table_arn
}

output "dynamodb_table_billing_mode" {
  description = "Billing configuration applied to the DynamoDB table."
  value       = module.dynamodb.table_billing_mode
}

output "dynamodb_table_stream_arn" {
  description = "Stream ARN emitted by the DynamoDB table when streams are enabled."
  value       = module.dynamodb.table_stream_arn
}

output "ecs_service_name" {
  description = "Name of the ECS service running the API tasks."
  value       = module.ecs.service_name
}

output "ecs_alb_dns_name" {
  description = "Public DNS name of the Application Load Balancer fronting the ECS service."
  value       = module.ecs.alb_dns_name
}

output "cloudfront_distribution_domain" {
  description = "CloudFront distribution domain serving both static and API traffic."
  value       = module.cloudfront.distribution_domain_name
}
