variable "environment" {
  description = "Deployment environment identifier (e.g. dev, staging, prod)."
  type        = string
}

variable "project_name" {
  description = "Human-friendly project name used for tagging."
  type        = string
}

variable "region" {
  description = "AWS region where the infrastructure is provisioned."
  type        = string
}

variable "prefix" {
  description = "Global resource prefix applied to all names."
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block assigned to the VPC."
  type        = string
}

variable "rds_master_password" {
  description = "Master password for the environment's RDS instance."
  type        = string
  sensitive   = true
}

variable "bastion_instance_type" {
  description = "Instance type used for the bastion host."
  type        = string
  default     = "t3.small"
}

variable "bastion_key_name" {
  description = "EC2 key pair name used by the bastion instance."
  type        = string
  default     = "ec2-kp"
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
  default     = 10
}

variable "ecs_app_version" {
  description = "Application container version used when tagging images."
  type        = string
  default     = "1.0.2"
}
