# Module: DynamoDB Table

Provision an application DynamoDB table with configurable attributes, billing
mode, TTL, and optional global secondary indexes.

## Features
- Creates a DynamoDB table with caller-specified primary key schema.
- Supports on-demand (`PAY_PER_REQUEST`) or provisioned throughput.
- Optionally sets TTL attribute and global secondary indexes.
- Exposes key identifiers for downstream consumers.

## Usage
### PAY_PER_REQUEST (On-Demand)
```hcl
module "dynamodb" {
  source = "../../modules/dynamodb"

  prefix       = var.prefix
  project_name = var.project_name
  environment  = var.environment

  table_name   = "ddbt"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]
}
```

### PROVISIONED Throughput
```hcl
module "dynamodb" {
  source = "../../modules/dynamodb"

  prefix       = var.prefix
  project_name = var.project_name
  environment  = var.environment

  table_name    = "ddbt"
  billing_mode  = "PROVISIONED"
  hash_key      = "id"
  read_capacity = 20
  write_capacity = 10
  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]
}
```

## Inputs
| Name | Type | Default | Description |
|------|------|---------|-------------|
| `prefix` | `string` | n/a | Naming prefix for the table. |
| `project_name` | `string` | n/a | Project identifier for tagging. |
| `environment` | `string` | n/a | Environment label. |
| `table_name` | `string` | n/a | Logical table name appended to the prefix/project. |
| `billing_mode` | `string` | `"PAY_PER_REQUEST"` | Billing model (`PAY_PER_REQUEST` or `PROVISIONED`). |
| `hash_key` | `string` | n/a | Primary partition key name. |
| `range_key` | `string` | `""` | Optional sort key name. |
| `attributes` | `list(object)` | n/a | Attribute definitions (`name`, `type`). |
| `read_capacity` | `number` | `5` | Read capacity units when `billing_mode = "PROVISIONED"`. |
| `write_capacity` | `number` | `5` | Write capacity units when `billing_mode = "PROVISIONED"`. |
| `global_secondary_indexes` | `list(object)` | `[]` | GSI definitions (name/hash_key/range_key/capacity/projection). |
| `ttl_enabled` | `bool` | `false` | Toggle TTL support. |
| `ttl_attribute_name` | `string` | `"ttl"` | TTL attribute used when TTL is enabled. |

## Outputs
| Name | Description |
|------|-------------|
| `table_name` | Full DynamoDB table name. |
| `table_id` | Table identifier. |
| `table_arn` | Table ARN. |
| `table_billing_mode` | Active billing mode. |
| `table_hash_key` | Hash key attribute used. |
| `table_range_key` | Sort key attribute when defined. |
| `table_read_capacity` | Provisioned read capacity (null for on-demand). |
| `table_write_capacity` | Provisioned write capacity (null for on-demand). |
| `table_stream_arn` | Stream ARN when streams are enabled. |
| `table_global_secondary_indexes` | Details for any GSIs created. |

## Environment Variables
None.

## Notes
- When using provisioned mode, ensure `read_capacity` / `write_capacity` fit your expected workload.
- TTL requires `ttl_enabled = true` and the specified `ttl_attribute_name` present on items you want to expire.
