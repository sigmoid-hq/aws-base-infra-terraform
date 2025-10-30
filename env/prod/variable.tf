variable "environment" {
  description = "Deployment environment identifier (prod by default)."
  type        = string
  default     = "prod"
}

variable "project_name" {
  description = "Human-friendly project name used for tagging."
  type        = string
  default     = "aws-base-infra"
}

variable "region" {
  description = "AWS region where the production infrastructure resides."
  type        = string
  default     = "ap-northeast-2"
}

variable "prefix" {
  description = "Global resource prefix applied to all names."
  type        = string
  default     = "sigmoid"
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block assigned to the production VPC."
  type        = string
  default     = "10.10.0.0/16"
}

variable "rds_master_password" {
  description = "Master password for the production RDS instance."
  type        = string
  sensitive   = true
}

variable "bastion_instance_type" {
  description = "Instance type used for the production bastion host."
  type        = string
  default     = "t3.medium"
}

variable "bastion_key_name" {
  description = "EC2 key pair name used by the production bastion instance."
  type        = string
  default     = "ec2-kp-prod"
}

variable "rds_engine" {
  description = "Database engine identifier passed to the RDS module."
  type        = string
  default     = "mysql"
}

variable "rds_engine_version" {
  description = "Database engine version."
  type        = string
  default     = "8.0.42"
}

variable "rds_database_name" {
  description = "Initial database name created on the RDS instance."
  type        = string
  default     = "sigmoid_app"
}

variable "rds_port" {
  description = "Port the RDS instance listens on."
  type        = number
  default     = 3306
}

variable "rds_parameter_group_family" {
  description = "Parameter group family used by the RDS instance."
  type        = string
  default     = "mysql8.0"
}

variable "rds_backup_window" {
  description = "Preferred daily backup window for production RDS."
  type        = string
  default     = "02:00-04:00"
}

variable "rds_maintenance_window" {
  description = "Preferred weekly maintenance window for production RDS."
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "rds_cloudwatch_logs_exports" {
  description = "List of RDS log types exported to CloudWatch."
  type        = list(string)
  default     = ["error", "slowquery", "general"]
}

variable "rds_performance_insights_enabled" {
  description = "Toggle Performance Insights for production RDS."
  type        = bool
  default     = true
}

variable "ecs_repository_name" {
  description = "ECR repository name used by the ECS module."
  type        = string
  default     = "sigmoid-app"
}

variable "ecs_image_tag_mutability" {
  description = "Image tag mutability setting for the ECR repository."
  type        = string
  default     = "MUTABLE"
}

variable "ecs_keep_last_n_images" {
  description = "Number of container images to retain via lifecycle policy."
  type        = number
  default     = 30
}

variable "ecs_app_version" {
  description = "Application container version used when tagging images."
  type        = string
  default     = "1.0.2"
}
