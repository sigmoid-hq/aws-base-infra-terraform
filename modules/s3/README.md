# Module: S3 Buckets

Manage the trio of S3 buckets used by the baseline: the primary bucket for
artifacts/backups, a logging bucket, and an optional public static-asset bucket
with website hosting.

## Features
- Creates dedicated main, log, and asset buckets with consistent naming.
- Optionally enables versioning and public/static website hosting on the asset bucket.
- Configures CORS rules and bucket policy when public access is allowed.
- Seeds default `index.html` / `error.html` objects for static hosting.

## Usage
```hcl
module "s3" {
  source = "../../modules/s3"

  prefix       = var.prefix
  project_name = var.project_name

  enable_public_access = true
  enable_versioning    = true
  enable_hosting       = true
  index_document       = "index.html"
  error_document       = "error.html"
}
```

## Inputs
| Name | Type | Default | Description |
|------|------|---------|-------------|
| `prefix` | `string` | n/a | Naming prefix for all buckets. |
| `project_name` | `string` | n/a | Project identifier appended to bucket names. |
| `enable_public_access` | `bool` | `false` | Allow public reads on the asset bucket and configure policy. |
| `enable_versioning` | `bool` | `false` | Enable versioning on the asset bucket. |
| `enable_hosting` | `bool` | `false` | Turn on static website hosting for the asset bucket. |
| `index_document` | `string` | `"index.html"` | Key served as the website index. |
| `error_document` | `string` | `"error.html"` | Key served on HTTP errors. |
| `cors_allowed_headers` | `list(string)` | `["*"]` | Headers allowed by CORS. |
| `cors_allowed_methods` | `list(string)` | `["GET"]` | Methods allowed by CORS. |
| `cors_allowed_origins` | `list(string)` | `["*"]` | Origins allowed by CORS. |
| `cors_expose_headers` | `list(string)` | `["*"]` | Headers exposed via CORS. |
| `cors_max_age_seconds` | `number` | `3600` | CORS preflight cache duration. |

## Outputs
| Name | Description |
|------|-------------|
| `main_bucket_id` / `main_bucket_arn` | Identifier and ARN for the primary bucket. |
| `log_bucket_id` / `log_bucket_arn` | Identifier and ARN for the log bucket. |
| `asset_bucket_id` / `asset_bucket_arn` | Identifier and ARN for the asset bucket. |
| `asset_bucket_regional_domain_name` | Regional domain for the static asset bucket (used by CloudFront). |

## Environment Variables
None.

## Notes
- Static hosting should remain disabled in production unless a CDN or WAF sits in front of the asset bucket.
- The module writes default HTML pages from `modules/s3/static/`; replace them as needed.
