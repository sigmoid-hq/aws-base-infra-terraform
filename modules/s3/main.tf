locals {
    main_bucket_name = "${var.prefix}-${var.project_name}-main"
    log_bucket_name = "${var.prefix}-${var.project_name}-log"
    asset_bucket_name = "${var.prefix}-${var.project_name}-asset"
}

### --------------------------------------------------
### Main Bucket
### --------------------------------------------------
resource "aws_s3_bucket" "main" {
    bucket = local.main_bucket_name

    tags = {
        Name = local.main_bucket_name
    }
}

# Enable bucket versioning for main bucket
resource "aws_s3_bucket_versioning" "main" {
    bucket = aws_s3_bucket.main.id

    versioning_configuration {
        status = "Enabled"
    }
}

# Block public access for main bucket
resource "aws_s3_bucket_public_access_block" "main" {
    bucket = aws_s3_bucket.main.id

    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

### --------------------------------------------------
### Log Bucket
### --------------------------------------------------
resource "aws_s3_bucket" "log" {
    bucket = local.log_bucket_name

    tags = {
        Name = local.log_bucket_name
    }
}

# Enable bucket versioning for log bucket
resource "aws_s3_bucket_versioning" "log" {
    bucket = aws_s3_bucket.log.id

    versioning_configuration {
        status = "Enabled"
    }
}

# Block public access for log bucket
resource "aws_s3_bucket_public_access_block" "log" {
    bucket = aws_s3_bucket.log.id

    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

### --------------------------------------------------
### Asset Bucket
### --------------------------------------------------
resource "aws_s3_bucket" "asset" {
    bucket = local.asset_bucket_name

    tags = {
        Name = local.asset_bucket_name
    }
}

# Enable bucket versioning for asset bucket
resource "aws_s3_bucket_versioning" "asset" {
    count = var.enable_versioning ? 1 : 0
    bucket = aws_s3_bucket.asset.id

    versioning_configuration {
        status = "Enabled"
    }
}

# Block public access for asset bucket
resource "aws_s3_bucket_public_access_block" "asset" {
    bucket = aws_s3_bucket.asset.id

    block_public_acls = var.enable_public_access ? false : true
    block_public_policy = var.enable_public_access ? false : true
    ignore_public_acls = var.enable_public_access ? false : true
    restrict_public_buckets = var.enable_public_access ? false : true
}

# Configure static website hosting for asset bucket
resource "aws_s3_bucket_website_configuration" "asset" {
    count = var.enable_hosting ? 1 : 0
    bucket = aws_s3_bucket.asset.id

    index_document {
        suffix = var.index_document
    }

    error_document {
        key = var.error_document
    }
}

# CORS setting for asset bucket
resource "aws_s3_bucket_cors_configuration" "asset" {
    count = var.enable_public_access ? 1 : 0
    bucket = aws_s3_bucket.asset.id

    cors_rule {
        allowed_headers = var.cors_allowed_headers
        allowed_methods = var.cors_allowed_methods
        allowed_origins = var.cors_allowed_origins
        expose_headers = var.cors_expose_headers
        max_age_seconds = var.cors_max_age_seconds
    }
}

# Public access policy for asset bucket
resource "aws_s3_bucket_policy" "asset" {
    count = var.enable_public_access ? 1 : 0
    bucket = aws_s3_bucket.asset.id

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Sid = "PublicAccess"
                Effect = "Allow"
                Principal = "*"
                Action = "s3:GetObject"
                Resource = "${aws_s3_bucket.asset.arn}/*"
            }
        ]
    })

    depends_on = [aws_s3_bucket_public_access_block.asset]
}

### --------------------------------------------------
### AWS S3 Objects
### --------------------------------------------------
resource "aws_s3_object" "index" {
    count = var.enable_hosting ? 1 : 0
    bucket = aws_s3_bucket.asset.id
    key = "index.html"
    source = "${path.module}/static/index.html"
    content_type = "text/html"

    depends_on = [ aws_s3_bucket.asset ]
}

resource "aws_s3_object" "error" {
    count = var.enable_hosting ? 1 : 0
    bucket = aws_s3_bucket.asset.id
    key = "error.html"
    source = "${path.module}/static/error.html"
    content_type = "text/html"

    depends_on = [ aws_s3_bucket.asset ]
}