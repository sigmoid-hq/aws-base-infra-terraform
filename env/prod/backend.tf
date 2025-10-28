terraform {
    backend "s3" {
        bucket = "sigmoid-example-tfstate"
        key = "aws-base-infra-cdk/env/prod/terraform.tfstate"
        region = "ap-northeast-2"
    }
}