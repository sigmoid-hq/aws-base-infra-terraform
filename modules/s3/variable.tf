variable "tags" {
    type = map(string)
}

variable "prefix" {
    type = string
}

variable "project_name" {
    type = string
}

variable "enable_public_access" {
    type = bool
    default = false
}

variable "enable_versioning" {
    type = bool
    default = false
}

variable "enable_hosting" {
    type = bool
    default = false
}

variable "index_document" {
    type = string
    default = "index.html"
}

variable "error_document" {
    type = string
    default = "error.html"
}

variable "cors_allowed_headers" {
    type = list(string)
    default = ["*"]
}

variable "cors_allowed_methods" {
    type = list(string)
    default = ["GET"]
}

variable "cors_allowed_origins" {
    type = list(string)
    default = ["*"]
}

variable "cors_expose_headers" {
    type = list(string)
    default = ["*"]
}

variable "cors_max_age_seconds" {
    type = number
    default = 3600
}