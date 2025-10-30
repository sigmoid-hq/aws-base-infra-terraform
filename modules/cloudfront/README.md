# Module: CloudFront

Configure an Amazon CloudFront distribution that fronts both the static S3 site
(`/`) and the ECS API service (`/api/*`).

## Features
- Declares two origins: S3 for static assets and ALB for backend API.
- Enforces HTTPS for viewers and forwards required headers/cookies for the API.
- Provides configurable origin protocol policy for the API origin.
- Exposes distribution identifiers for DNS/cert integration.

## Usage
```hcl
module "cloudfront" {
  source = "../../modules/cloudfront"

  environment = var.environment

  static_s3_domain_name      = module.s3.asset_bucket_regional_domain_name
  api_domain_name            = module.ecs.alb_dns_name
  api_origin_protocol_policy = "http-only"
}
```

## Inputs
| Name | Type | Default | Description |
|------|------|---------|-------------|
| `environment` | `string` | n/a | Environment label used in tagging. |
| `static_s3_domain_name` | `string` | n/a | Regional domain name of the S3 website origin. |
| `api_domain_name` | `string` | n/a | Domain (typically ALB DNS) for the API origin. |
| `api_origin_protocol_policy` | `string` | `"http-only"` | How CloudFront connects to the API origin (`http-only`, `https-only`, `match-viewer`). |

## Outputs
| Name | Description |
|------|-------------|
| `distribution_id` | CloudFront distribution identifier. |
| `distribution_arn` | Distribution ARN. |
| `distribution_domain_name` | Public domain name assigned by CloudFront. |
| `distribution_hosted_zone_id` | Hosted zone ID used for Route53 alias records. |

## Environment Variables
None.

## Notes
- Default certificate is the CloudFront-managed wildcard. Swap for an ACM certificate in us-east-1 if you need custom domains.
- Adjust cache behaviour and headers if your API requires additional forwarded headers/cookies.
