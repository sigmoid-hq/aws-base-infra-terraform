locals {
    common_tags = {
        Environment = var.environment
        Project = var.project_name
        ManagedBy = "Sigmoid"
    }
}

module "iam" {
    source = "../../modules/iam"

    prefix = var.prefix
    project_name = var.project_name
    environment = var.environment
}

module "vpc" {
    source = "../../modules/vpc"

    prefix = var.prefix
    project_name = var.project_name
    environment = var.environment
    region = var.region
    vpc_cidr = var.vpc_cidr
}

module "bastion" {
    source = "../../modules/ec2"

    prefix = var.prefix
    project_name = var.project_name
    environment = var.environment
    region = var.region
    vpc_id = module.vpc.vpc_id
    subnet_id = module.vpc.public_subnet_ids[0]
    instance_type = "t3.small"
    key_name = "ec2-kp"
    instance_profile_name = module.iam.poweruser_instance_profile_name
    instance_name = "bastion"
}

module "s3" {
    source = "../../modules/s3"

    prefix = var.prefix
    project_name = var.project_name
    enable_public_access = true
    enable_versioning = true
    enable_hosting = true
    index_document = "index.html"
    error_document = "error.html"
    cors_allowed_headers = ["*"]
    cors_allowed_methods = ["GET"]
    cors_allowed_origins = ["*"]
    cors_expose_headers = ["Date", "ETag", "x-amz-server-side-encryption", "x-amz-request-id", "x-amz-id-2"]
    cors_max_age_seconds = 3600
}

module "rds" {
    source = "../../modules/rds"
}

module "dynamodb" {
    source = "../../modules/dynamodb"

    prefix = var.prefix
    project_name = var.project_name
    environment = var.environment
    table_name = "ddbt"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "id"
    attributes = [
        {
            name = "id"
            type = "S"
        }
    ]
}

module "ecs" {
    source = "../../modules/ecs"
}

module "cloudfront" {
    source = "../../modules/cloudfront"
}
