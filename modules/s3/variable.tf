variable "prefix" {
    description = "Prefix for the resources"
    type = string
}

variable "project_name" {
    description = "Project name"
    type = string
}

variable "enable_public_access" {
    description = "Enable public access to the S3 bucket"
    type = bool
    default = false
}

variable "enable_versioning" {
    description = "Enable versioning for the S3 bucket"
    type = bool
    default = false
}

variable "enable_hosting" {
    description = "Enable static websitehosting for the S3 bucket"
    type = bool
    default = false
}

variable "index_document" {
    description = "Index document for the S3 bucket"
    type = string
    default = "index.html"
}

variable "error_document" {
    description = "Error document for the S3 bucket"
    type = string
    default = "error.html"
}

variable "cors_allowed_headers" {
    description = "Allowed headers for the CORS configuration"
    type = list(string)
    default = ["*"]
}

variable "cors_allowed_methods" {
    description = "Allowed methods for the CORS configuration"
    type = list(string)
    default = ["GET"]
}

variable "cors_allowed_origins" {
    description = "Allowed origins for the CORS configuration"
    type = list(string)
    default = ["*"]
}

variable "cors_expose_headers" {
    description = "Expose headers for the CORS configuration"
    type = list(string)
    default = ["*"]
}

variable "cors_max_age_seconds" {
    description = "Max age seconds for the CORS configuration"
    type = number
    default = 3600
}