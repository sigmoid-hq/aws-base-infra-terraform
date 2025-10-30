### --------------------------------------------------
### CloudFront Distribution
### --------------------------------------------------
resource "aws_cloudfront_distribution" "main" {
  enabled         = true
  is_ipv6_enabled = true
  price_class     = "PriceClass_200"

  # S3 Static website origin
  origin {
    domain_name         = var.static_s3_domain_name
    origin_id           = "static-site"
  }

  # ECS API service origin
  origin {
    domain_name         = var.api_domain_name
    origin_id           = "api-service"

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_protocol_policy   = var.api_origin_protocol_policy
      origin_ssl_protocols     = ["TLSv1.2"]
    }
  }

  # Default cache rule (s3 static origin setting)
  default_cache_behavior {
    target_origin_id       = "static-site"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    forwarded_values {
      query_string = false
      headers      = []
      cookies {
        forward = "none"
      }
    }
  }

  # API cache rule (ecs api service origin setting)
  ordered_cache_behavior {
    path_pattern           = "api/*"
    target_origin_id       = "api-service"
    viewer_protocol_policy = "https-only"
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "POST", "PUT", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    compress               = false
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0

    forwarded_values {
      query_string = true
      headers      = ["Authorization"]
      cookies {
        forward = "all"
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "sigmoid-app-cloudfront-${var.environment}"
  }
}
