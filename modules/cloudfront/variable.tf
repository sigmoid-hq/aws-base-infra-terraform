variable "environment" {
  description = "Environment"
  type        = string
}

variable "static_s3_domain_name" {
  description = "Regional domain name of the S3 bucket serving the static site."
  type        = string
}

variable "api_domain_name" {
  description = "Domain name (typically ALB DNS) that serves the API."
  type        = string
}

variable "api_origin_protocol_policy" {
  description = "Protocol policy CloudFront uses when connecting to the API origin."
  type        = string
  default     = "http-only"

  validation {
    condition     = contains(["http-only", "https-only", "match-viewer"], var.api_origin_protocol_policy)
    error_message = "api_origin_protocol_policy must be one of: http-only, https-only, match-viewer."
  }
}
