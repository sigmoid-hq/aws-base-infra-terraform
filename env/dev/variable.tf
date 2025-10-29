variable "environment" {
  type    = string
  default = "dev"
}

variable "project_name" {
  type    = string
  default = "aws-base-infra"
}

variable "region" {
  type    = string
  default = "ap-northeast-2"
}

variable "prefix" {
  type    = string
  default = "sigmoid"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "rds_master_password" {
  description = "Master password for the dev RDS instance."
  type        = string
  sensitive   = true
}
