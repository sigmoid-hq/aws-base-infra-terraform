output "main_bucket_id" {
    description = "ID of the primary S3 bucket."
    value       = aws_s3_bucket.main.id
}

output "main_bucket_arn" {
    description = "ARN of the primary S3 bucket."
    value       = aws_s3_bucket.main.arn
}

output "log_bucket_id" {
    description = "ID of the log storage S3 bucket."
    value       = aws_s3_bucket.log.id
}

output "log_bucket_arn" {
    description = "ARN of the log storage S3 bucket."
    value       = aws_s3_bucket.log.arn
}

output "asset_bucket_id" {
    description = "ID of the asset hosting S3 bucket."
    value       = aws_s3_bucket.asset.id
}

output "asset_bucket_arn" {
    description = "ARN of the asset hosting S3 bucket."
    value       = aws_s3_bucket.asset.arn
}

output "asset_bucket_regional_domain_name" {
    description = "Regional domain name of the asset hosting S3 bucket."
    value       = aws_s3_bucket.asset.bucket_regional_domain_name
}
