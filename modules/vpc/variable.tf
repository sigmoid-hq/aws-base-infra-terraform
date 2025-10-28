variable "prefix" {
    description = "Prefix for the resources"
    type = string
}

variable "project_name" {
    description = "Project name"
    type = string
}

variable "environment" {
    description = "Environment"
    type = string
}

variable "region" {
    description = "Region"
    type = string
}

variable "vpc_cidr" {
    description = "VPC CIDR"
    type = string
}
