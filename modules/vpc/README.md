# Module: VPC

Provision the network foundation for an AWS environment, including a VPC,
public/private subnets across available AZs, Internet/NAT gateways, route
tables, and supporting IAM data sources.

## Features
- Creates a VPC with customizable CIDR range.
- Discovers available AZs and lays out public/private subnets evenly.
- Builds Internet Gateway, per-AZ NAT gateways, and associated route tables.
- Exposes subnet, gateway, and routing identifiers for downstream modules.

## Usage
```hcl
module "vpc" {
  source = "../../modules/vpc"

  prefix       = var.prefix
  project_name = var.project_name
  environment  = var.environment

  region   = var.region
  vpc_cidr = var.vpc_cidr
}
```

## Inputs
| Name | Type | Default | Description |
|------|------|---------|-------------|
| `prefix` | `string` | n/a | Global resource prefix used in naming. |
| `project_name` | `string` | n/a | Friendly project name applied to tags. |
| `environment` | `string` | n/a | Environment identifier (dev, prod, etc.). |
| `region` | `string` | n/a | AWS region used when querying AZs. |
| `vpc_cidr` | `string` | n/a | IPv4 CIDR block assigned to the VPC. |

## Outputs
| Name | Description |
|------|-------------|
| `vpc_id` | Identifier of the VPC created by the module. |
| `vpc_cidr` | CIDR block associated with the VPC. |
| `availability_zones` | Names of AZs used when creating subnets. |
| `public_subnet_ids` | IDs of the public subnets (one per AZ). |
| `private_subnet_ids` | IDs of the private subnets (one per AZ). |
| `public_route_table_id` | Route table shared by public subnets. |
| `private_route_table_ids` | Route tables associated with each private subnet. |
| `internet_gateway_id` | Internet Gateway attached to the VPC. |
| `nat_gateway_ids` | NAT Gateway IDs created per AZ. |
| `nat_eip_ids` | Elastic IP allocation IDs attached to NAT gateways. |

## Environment Variables
None. All configuration is passed in via module inputs.

## Notes
- At least two Availability Zones must be available in the selected region.
- NAT gateways incur hourly + data processing charges; adjust as needed for cost-sensitive environments.
