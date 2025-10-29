# Derive naming, networking, and feature toggles once up front.
locals {
  identifier_source = join("-", compact([var.prefix, var.project_name, var.environment, var.name]))
  identifier        = substr(replace(lower(local.identifier_source), "_", "-"), 0, 63)

  subnet_group_name    = substr("${local.identifier}-subnets", 0, 63)
  parameter_group_name = substr("${local.identifier}-params", 0, 255)

  # Prefer a deterministic snapshot id when we actually take one.
  final_snapshot_identifier = var.skip_final_snapshot ? null : (var.final_snapshot_identifier != "" ? var.final_snapshot_identifier : format("%s-final", local.identifier))

  # Compose explicit ingress targets (VPC CIDR + custom CIDRs).
  allowed_cidr_blocks = distinct(concat(
    var.allow_ingress_from_vpc && var.vpc_cidr != "" ? [var.vpc_cidr] : [],
    var.allowed_cidr_blocks
  ))

  # Expand ingress matrix for SG rule rendering.
  ingress_rules = concat(
    [for cidr in local.allowed_cidr_blocks : {
      description     = "Ingress from ${cidr}"
      cidr_blocks     = [cidr]
      security_groups = []
    }],
    [for sg in var.allowed_security_group_ids : {
      description     = "Ingress from ${sg}"
      cidr_blocks     = []
      security_groups = [sg]
    }]
  )

  # Merge mandatory tags with caller overrides.
  tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Sigmoid"
    },
    var.tags,
    {
      Name = local.identifier
    }
  )

  # Optional feature toggles with friendly defaults.
  parameter_group_enabled         = var.parameter_group_family != ""
  max_allocated_storage           = var.max_allocated_storage > 0 ? var.max_allocated_storage : null
  kms_key_id                      = var.storage_encrypted && var.kms_key_id != "" ? var.kms_key_id : null
  monitoring_role_arn             = var.monitoring_interval > 0 && var.monitoring_role_arn != "" ? var.monitoring_role_arn : null
  performance_insights_kms_key_id = var.performance_insights_enabled && var.performance_insights_kms_key_id != "" ? var.performance_insights_kms_key_id : null
  backup_window                   = var.backup_window != "" ? var.backup_window : null
  maintenance_window              = var.maintenance_window != "" ? var.maintenance_window : null
}

### --------------------------------------------------
### Security Group
### --------------------------------------------------
resource "aws_security_group" "main" {
  name        = "${local.identifier}-sg"
  description = "Security group for ${local.identifier} RDS instance"
  vpc_id      = var.vpc_id

  # Render ingress once for each distinct CIDR or security group.
  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      description     = ingress.value.description
      from_port       = var.port
      to_port         = var.port
      protocol        = "tcp"
      cidr_blocks     = ingress.value.cidr_blocks
      security_groups = ingress.value.security_groups
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, { Name = "${local.identifier}-sg" })
}

### --------------------------------------------------
### Subnet & Parameter Groups
### --------------------------------------------------
resource "aws_db_subnet_group" "main" {
  name        = local.subnet_group_name
  subnet_ids  = var.subnet_ids
  description = "Subnets for ${local.identifier} RDS instance"

  tags = merge(local.tags, { Name = local.subnet_group_name })
}

resource "aws_db_parameter_group" "main" {
  count       = local.parameter_group_enabled ? 1 : 0
  name        = local.parameter_group_name
  family      = var.parameter_group_family
  description = "Parameter group for ${local.identifier}"

  # Allow arbitrary parameter overrides without changing the module.
  dynamic "parameter" {
    for_each = var.parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = lookup(parameter.value, "apply_method", "pending-reboot")
    }
  }

  tags = local.tags
}

### --------------------------------------------------
### RDS Instance
### --------------------------------------------------
resource "aws_db_instance" "main" {
  identifier             = local.identifier
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  storage_type           = var.storage_type
  allocated_storage      = var.allocated_storage
  max_allocated_storage  = local.max_allocated_storage
  storage_encrypted      = var.storage_encrypted
  kms_key_id             = local.kms_key_id
  username               = var.master_username
  password               = var.master_password
  port                   = var.port
  db_name                = var.database_name
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = distinct(concat([aws_security_group.main.id], var.additional_security_group_ids))

  publicly_accessible = var.publicly_accessible
  multi_az            = var.multi_az

  backup_retention_period = var.backup_retention_period
  backup_window           = local.backup_window
  maintenance_window      = local.maintenance_window

  apply_immediately          = var.apply_immediately
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  deletion_protection        = var.deletion_protection
  skip_final_snapshot        = var.skip_final_snapshot
  final_snapshot_identifier  = local.final_snapshot_identifier
  copy_tags_to_snapshot      = true

  enabled_cloudwatch_logs_exports     = var.cloudwatch_logs_exports
  performance_insights_enabled        = var.performance_insights_enabled
  performance_insights_kms_key_id     = local.performance_insights_kms_key_id
  monitoring_interval                 = var.monitoring_interval
  monitoring_role_arn                 = local.monitoring_role_arn
  option_group_name                   = var.option_group_name != "" ? var.option_group_name : null
  parameter_group_name                = length(aws_db_parameter_group.main) > 0 ? aws_db_parameter_group.main[0].name : null
  iam_database_authentication_enabled = var.iam_database_authentication

  # Always propagate tags to snapshots and related resources.
  tags = local.tags

  depends_on = [aws_db_subnet_group.main]
}
