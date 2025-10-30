output "distribution_id" {
  description = "Identifier of the CloudFront distribution."
  value       = aws_cloudfront_distribution.main.id
}

output "distribution_arn" {
  description = "ARN of the CloudFront distribution."
  value       = aws_cloudfront_distribution.main.arn
}

output "distribution_domain_name" {
  description = "Domain name assigned to the CloudFront distribution."
  value       = aws_cloudfront_distribution.main.domain_name
}

output "distribution_hosted_zone_id" {
  description = "Route53 hosted zone ID for the CloudFront distribution (useful for alias records)."
  value       = aws_cloudfront_distribution.main.hosted_zone_id
}
