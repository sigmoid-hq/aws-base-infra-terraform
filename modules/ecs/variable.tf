variable "region" {
  description = "Region"
  type        = string
}

variable "account_id" {
  description = "Account ID"
  type        = string
}

variable "prefix" {
  description = "Prefix"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "service_subnet_ids" {
  description = "Subnet IDs where ECS tasks run"
  type        = list(string)
}

variable "alb_subnet_ids" {
  description = "Subnet IDs used by the public ALB"
  type        = list(string)
}

variable "repository_name" {
  description = "Name of the repository"
  type        = string
}

variable "image_scanning_configuration" {
  description = "Enable image scanning on push"
  type        = bool
  default     = true
}

variable "image_tag_mutability" {
  description = "Image tag mutability"
  type        = string
  default     = "MUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "Image tag mutability must be one of: MUTABLE, IMMUTABLE"
  }
}

variable "keep_last_n_images" {
  description = "Keep last n images"
  type        = number
  default     = 10
}

variable "app_version" {
  description = "App version"
  type        = string
  default     = "1.0.0"
}

variable "container_insights" {
  description = "Container insights"
  type        = string
  default     = "enabled"
}

variable "desired_count" {
  description = "Desired count"
  type        = number
  default     = 1
}

variable "task_execution_role_arn" {
  description = "IAM role ARN used by ECS tasks for pulling images and writing logs"
  type        = string
  default     = ""
}

variable "log_retention_in_days" {
  description = "Retention period for application CloudWatch log group"
  type        = number
  default     = 14
}

variable "log_stream_prefix" {
  description = "Prefix applied to CloudWatch log streams created by the task"
  type        = string
  default     = "app"
}
