# Module: RDS (MySQL-Compatible)

Provision a highly configurable Amazon RDS instance (default MySQL) together
with subnet/security groups, optional parameter groups, and logging features.

## Features
- Creates DB subnet group across supplied private subnets.
- Builds a dedicated security group with CIDR and security-group based ingress rules.
- Supports engine/instance sizing, storage autoscaling, encryption, and IAM auth toggles.
- Optional CloudWatch log export, Performance Insights, and parameter overrides.

## Usage
```hcl
module "rds" {
  source = "../../modules/rds"

  prefix       = var.prefix
  project_name = var.project_name
  environment  = var.environment

  name       = "app-db"
  vpc_id     = module.vpc.vpc_id
  vpc_cidr   = module.vpc.vpc_cidr
  subnet_ids = module.vpc.private_subnet_ids

  engine               = var.rds_engine
  engine_version       = var.rds_engine_version
  port                 = var.rds_port
  database_name        = var.rds_database_name
  master_password      = var.rds_master_password
  parameter_group_family = var.rds_parameter_group_family
}
```

## Inputs
| Name | Type | Default | Description |
|------|------|---------|-------------|
| `prefix` | `string` | n/a | Naming prefix applied across DB-related resources. |
| `project_name` | `string` | n/a | Project identifier for tagging. |
| `environment` | `string` | n/a | Environment identifier. |
| `name` | `string` | n/a | Suffix used for DB resources (must start with a letter). |
| `vpc_id` | `string` | n/a | VPC hosting the database. |
| `vpc_cidr` | `string` | `""` | VPC CIDR automatically allowed when `allow_ingress_from_vpc = true`. |
| `subnet_ids` | `list(string)` | n/a | Private subnet IDs (minimum two). |
| `engine` | `string` | `"mysql"` | Database engine identifier. |
| `engine_version` | `string` | `"8.0.42"` | Database engine version. |
| `instance_class` | `string` | `"db.t3.small"` | RDS instance size. |
| `allocated_storage` | `number` | `20` | Initial storage (GiB). |
| `max_allocated_storage` | `number` | `100` | Storage autoscaling ceiling (0 disables). |
| `storage_encrypted` | `bool` | `true` | Enable storage encryption. |
| `kms_key_id` | `string` | `""` | Custom KMS key when encryption is enabled. |
| `database_name` | `string` | `"appdb"` | Initial schema created on startup. |
| `master_username` | `string` | `"sigmoid"` | Master user name. |
| `master_password` | `string` | n/a | Master password (sensitive). |
| `port` | `number` | `3306` | Database listener port. |
| `publicly_accessible` | `bool` | `false` | Expose the instance to the public Internet. |
| `backup_retention_period` | `number` | `7` | Automated backup retention (days). |
| `backup_window` | `string` | `""` | Preferred backup window (`hh:mm-hh:mm`). |
| `maintenance_window` | `string` | `""` | Preferred maintenance window (`ddd:hh:mm-ddd:hh:mm`). |
| `allow_ingress_from_vpc` | `bool` | `true` | Automatically allow VPC CIDR access. |
| `allowed_cidr_blocks` | `list(string)` | `[]` | Additional CIDRs allowed to connect. |
| `allowed_security_group_ids` | `list(string)` | `[]` | Security groups allowed inbound access. |
| `cloudwatch_logs_exports` | `list(string)` | `[]` | Log types exported to CloudWatch (`error`, `slowquery`, etc.). |
| `performance_insights_enabled` | `bool` | `false` | Toggle Performance Insights. |
| `parameter_group_family` | `string` | `"mysql8.0"` | Parameter group family. Required when using `parameters`. |
| `parameters` | `list(object)` | `[]` | Custom parameter overrides (name/value/apply_method). |
| `option_group_name` | `string` | `""` | Associate an existing option group by name. |
| `tags` | `map(string)` | `{}` | Extra tags merged into all created resources. |

> See `variable.tf` for additional advanced knobs (IAM auth, monitoring, deletion protection, etc.).

## Outputs
| Name | Description |
|------|-------------|
| `instance_identifier` | Database instance identifier. |
| `endpoint` | Connection endpoint (host:port without scheme). |
| `port` | Listener port number. |
| `security_group_id` | Security group protecting the instance. |
| `subnet_group_name` | Name of the DB subnet group. |

## Environment Variables
None. Supply secrets (e.g. `master_password`) through `terraform.tfvars` or CLI variables.

## Notes
- Avoid checking `master_password` into version control. Source it from a secure secret store when running Terraform.
- When `skip_final_snapshot = false`, provide `final_snapshot_identifier` to control snapshot naming during destroys.
