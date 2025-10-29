variable "prefix" {
  description = "Prefix used for naming RDS resources."
  type        = string
}

variable "project_name" {
  description = "Project name used for tagging and naming."
  type        = string
}

variable "environment" {
  description = "Deployment environment identifier (e.g. dev, prod)."
  type        = string
}

variable "name" {
  description = "Friendly identifier appended to resource names (must start with a letter)."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]+$", var.name))
    error_message = "The name must start with a letter and contain only letters, numbers, or hyphens."
  }
}

variable "vpc_id" {
  description = "Identifier of the VPC that hosts the database."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC, used when allow_ingress_from_vpc is true."
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "Subnets that make up the RDS subnet group (minimum two, spanning AZs)."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "Provide at least two subnet identifiers for the RDS subnet group."
  }
}

variable "engine" {
  description = "Database engine to use (e.g. postgres, mysql)."
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "Version of the database engine."
  type        = string
  default     = "8.0.42"
}

variable "instance_class" {
  description = "RDS instance class (e.g. db.t4g.small)."
  type        = string
  default     = "db.t3.small"
}

variable "storage_type" {
  description = "Type of storage to use (gp2, gp3, io1, standard)."
  type        = string
  default     = "gp3"

  validation {
    condition     = contains(["gp2", "gp3", "io1", "standard"], var.storage_type)
    error_message = "Storage type must be one of gp2, gp3, io1, or standard."
  }
}

variable "allocated_storage" {
  description = "Initial storage size in GiB."
  type        = number
  default     = 20

  validation {
    condition     = var.allocated_storage >= 20
    error_message = "Allocated storage must be at least 20 GiB."
  }
}

variable "max_allocated_storage" {
  description = "Maximum storage for autoscaling (set to 0 to disable)."
  type        = number
  default     = 100

  validation {
    condition     = var.max_allocated_storage == 0 || var.max_allocated_storage >= var.allocated_storage
    error_message = "Max allocated storage must be 0 or greater than the allocated storage."
  }
}

variable "storage_encrypted" {
  description = "Enable storage encryption."
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "KMS key identifier for encryption. Required when storage_encrypted is true and default key is not desired."
  type        = string
  default     = ""
}

variable "database_name" {
  description = "Logical database name created within the instance."
  type        = string
  default     = "appdb"

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_]*$", var.database_name))
    error_message = "Database name must start with a letter and contain only letters, numbers, or underscores."
  }
}

variable "master_username" {
  description = "Master username for the database."
  type        = string
  default     = "sigmoid"

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_]*$", var.master_username))
    error_message = "Master username must start with a letter and contain only letters, numbers, or underscores."
  }
}

variable "master_password" {
  description = "Master password for the database."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.master_password) >= 8
    error_message = "Master password must be at least 8 characters long."
  }
}

variable "port" {
  description = "Port that the database listens on."
  type        = number
  default     = 3306

  validation {
    condition     = var.port > 0 && var.port <= 65535
    error_message = "Port must be between 1 and 65535."
  }
}

variable "publicly_accessible" {
  description = "Whether the instance should have a public IP."
  type        = bool
  default     = false
}

variable "multi_az" {
  description = "Deploy the instance across multiple Availability Zones."
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Number of days to retain backups."
  type        = number
  default     = 7

  validation {
    condition     = var.backup_retention_period >= 0 && var.backup_retention_period <= 35
    error_message = "Backup retention must be between 0 and 35 days."
  }
}

variable "backup_window" {
  description = "Preferred daily backup window (hh24:mi-hh24:mi). Leave empty to let AWS choose."
  type        = string
  default     = ""
}

variable "maintenance_window" {
  description = "Preferred weekly maintenance window (ddd:hh24:mi-ddd:hh24:mi). Leave empty to let AWS choose."
  type        = string
  default     = ""
}

variable "apply_immediately" {
  description = "Apply modifications immediately (may cause downtime)."
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Enable automatic minor engine version upgrades."
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Prevent accidental deletion of the instance."
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when deleting the instance."
  type        = bool
  default     = true
}

variable "final_snapshot_identifier" {
  description = "Identifier for the final snapshot when skip_final_snapshot is false."
  type        = string
  default     = ""
}

variable "allow_ingress_from_vpc" {
  description = "Automatically allow inbound traffic from the VPC CIDR."
  type        = bool
  default     = true
}

variable "allowed_cidr_blocks" {
  description = "Additional CIDR blocks granted ingress to the database."
  type        = list(string)
  default     = []
}

variable "allowed_security_group_ids" {
  description = "Security groups granted ingress to the database."
  type        = list(string)
  default     = []
}

variable "additional_security_group_ids" {
  description = "Additional security groups attached to the RDS instance."
  type        = list(string)
  default     = []
}

variable "cloudwatch_logs_exports" {
  description = "List of log types to export to CloudWatch Logs."
  type        = list(string)
  default     = []
}

variable "performance_insights_enabled" {
  description = "Enable Performance Insights."
  type        = bool
  default     = false
}

variable "performance_insights_kms_key_id" {
  description = "KMS key for encrypting Performance Insights data."
  type        = string
  default     = ""
}

variable "monitoring_interval" {
  description = "Enhanced monitoring interval in seconds (0 disables)."
  type        = number
  default     = 0

  validation {
    condition     = contains([0, 1, 5, 10, 15, 30, 60], var.monitoring_interval)
    error_message = "Monitoring interval must be one of 0, 1, 5, 10, 15, 30, or 60."
  }
}

variable "monitoring_role_arn" {
  description = "IAM role ARN for Enhanced Monitoring."
  type        = string
  default     = ""
}

variable "iam_database_authentication" {
  description = "Enable IAM database authentication."
  type        = bool
  default     = false
}

variable "parameter_group_family" {
  description = "Custom parameter group family (override when using a different engine/version)."
  type        = string
  default     = "mysql8.0"
}

variable "parameters" {
  description = "Custom parameter overrides applied when a parameter group is created."
  type = list(object({
    name         = string
    value        = string
    apply_method = optional(string, "pending-reboot")
  }))
  default = []

  validation {
    condition     = length(var.parameters) == 0 || var.parameter_group_family != ""
    error_message = "Parameter overrides require parameter_group_family to be set."
  }
}

variable "option_group_name" {
  description = "Existing option group to associate with the instance."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Additional tags merged into every created resource."
  type        = map(string)
  default     = {}
}
