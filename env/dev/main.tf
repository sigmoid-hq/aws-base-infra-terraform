module "iam" {
    source = "../../modules/iam"
}

module "vpc" {
    source = "../../modules/vpc"
}

module "bastion" {
    source = "../../modules/ec2"
}

module "s3" {
    source = "../../modules/s3"
}

module "cloudfront" {
    source = "../../modules/cloudfront"
}

module "rds" {
    source = "../../modules/rds"
}

module "dynamodb" {
    source = "../../modules/dynamodb"
}

module "ecs" {
    source = "../../modules/ecs"
}