variable "region" {
    description = "Region"
    type = string
}

variable "account_id" {
    description = "Account ID"
    type = string
}

variable "environment" {
    description = "Environment"
    type = string
}

variable "repository_name" {
    description = "Name of the repository"
    type = string
}

variable "image_tag_mutability" {
    description = "Image tag mutability"
    type = string
    default = "MUTABLE"

    validation {
        condition = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
        error_message = "Image tag mutability must be one of: MUTABLE, IMMUTABLE"
    }
}

variable "keep_last_n_images" {
    description = "Keep last n images"
    type = number
    default = 10
}

variable "app_version" {
    description = "App version"
    type = string
    default = "1.0.0"
}