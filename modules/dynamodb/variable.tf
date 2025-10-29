variable "prefix" {
  description = "Prefix for the DynamoDB table"
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

variable "table_name" {
  description = "Name of the DynamoDB table"
  type = string
}

variable "billing_mode" {
  description = "Billing mode for the DynamoDB table"
  type = string
  default = "PAY_PER_REQUEST"

  validation {
    condition = contains(["PAY_PER_REQUEST", "PROVISIONED"], var.billing_mode)
    error_message = "Billing mode must be one of: PAY_PER_REQUEST, PROVISIONED"
  }
}

variable "hash_key" {
  description = "Hash key for the DynamoDB table"
  type = string
}

variable "range_key" {
  description = "Range key for the DynamoDB table"
  type = string
  default = ""
}

variable "attributes" {
  description = "Attributes for the DynamoDB table"
  type = list(object({
    name = string
    type = string
  }))
}

variable "read_capacity" {
  description = "Read capacity for the DynamoDB table (only for PROVISIONED mode)"
  type = number
  default = 5

  validation {
    condition = var.billing_mode == "PAY_PER_REQUEST" || (var.read_capacity >= 1 && var.read_capacity <= 10000)
    error_message = "Read capacity must be between 1 and 10000 when billing mode is PROVISIONED"
  }
}

variable "write_capacity" {
  description = "Write capacity for the DynamoDB table (only for PROVISIONED mode)"
  type = number
  default = 5

  validation {
    condition = var.billing_mode == "PAY_PER_REQUEST" || (var.write_capacity >= 1 && var.write_capacity <= 10000)
    error_message = "Write capacity must be between 1 and 10000 when billing mode is PROVISIONED"
  }
}

variable "global_secondary_indexes" {
  description = "Global secondary indexes for the DynamoDB table"
  type = list(object({
    name = string
    hash_key = string
    range_key = string
    write_capacity = number
    read_capacity = number
    projection_type = string
  }))
  default = []
}

variable "ttl_enabled" {
  description = "TTL for the DynamoDB table"
  type = bool
  default = false
}

variable "ttl_attribute_name" {
  description = "TTL attribute name for the DynamoDB table"
  type = string
  default = "ttl"
}