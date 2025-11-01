terraform {
    backend "s3" {
        bucket = "sigmoid-example-tfstate"
        key = "aws-base-infra-terraform/env/dev/terraform.tfstate"
        region = "ap-northeast-2"
    }
}