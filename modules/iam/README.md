# Module: IAM

Create the shared IAM roles and instance profiles needed by the baseline
infrastructure (bastion hosts, operators, and ECS tasks).

## Features
- Power user EC2 role + instance profile for administration tasks.
- Read-only EC2 role + instance profile for observability or auditors.
- ECS task execution role with the managed policy required for Fargate tasks.
- All resources are tagged consistently with prefix/project/environment.

## Usage
```hcl
module "iam" {
  source = "../../modules/iam"

  prefix       = var.prefix
  project_name = var.project_name
  environment  = var.environment
}
```

## Inputs
| Name | Type | Default | Description |
|------|------|---------|-------------|
| `prefix` | `string` | n/a | Naming prefix applied to all IAM resources. |
| `project_name` | `string` | n/a | Friendly project label used in tags. |
| `environment` | `string` | n/a | Environment identifier (dev, prod, etc.). |

## Outputs
| Name | Description |
|------|-------------|
| `poweruser_role_name` / `poweruser_role_arn` | Power-user IAM role details. |
| `poweruser_instance_profile_name` / `poweruser_instance_profile_arn` | EC2 instance profile for power-user role. |
| `readonly_role_name` / `readonly_role_arn` | Read-only IAM role details. |
| `readonly_instance_profile_name` / `readonly_instance_profile_arn` | EC2 instance profile for read-only role. |
| `ecs_task_execution_role_name` / `ecs_task_execution_role_arn` | IAM role used by ECS tasks to pull images and publish logs. |

## Environment Variables
None. AWS credentials must be configured when applying Terraform, but the module itself does not read environment variables.

## Notes
- Attach additional permissions to the generated roles as needed per workload.
- The ECS task execution role is created with the AWS managed policy `AmazonECSTaskExecutionRolePolicy`.
