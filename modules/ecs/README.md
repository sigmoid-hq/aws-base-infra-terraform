# Module: ECS (Fargate + ECR + ALB)

Package the complete container runtime stack: ECR repository, CloudWatch log
group, Fargate cluster/service, Application Load Balancer, and supporting
security groups. Includes a local build/push step for the reference container.

## Features
- Creates/maintains an ECR repository with lifecycle policy and image scanning.
- Generates task definitions from `taskdef/app.json` via `templatefile`.
- Provisions ECS cluster, service, log group, target group, and security groups.
- Associates the service with a public ALB for `/api` traffic.
- Optionally retains a configurable number of tagged images.

## Usage
```hcl
module "ecs" {
  source = "../../modules/ecs"

  prefix       = var.prefix
  project_name = var.project_name
  environment  = var.environment

  region     = var.region
  vpc_id     = module.vpc.vpc_id
  account_id = data.aws_caller_identity.current.account_id

  service_subnet_ids = module.vpc.private_subnet_ids
  alb_subnet_ids     = module.vpc.public_subnet_ids

  repository_name         = var.ecs_repository_name
  image_tag_mutability    = var.ecs_image_tag_mutability
  keep_last_n_images      = var.ecs_keep_last_n_images
  app_version             = var.ecs_app_version
  task_execution_role_arn = module.iam.ecs_task_execution_role_arn
}
```

## Inputs
| Name | Type | Default | Description |
|------|------|---------|-------------|
| `region` | `string` | n/a | AWS region for ECS resources. |
| `account_id` | `string` | n/a | AWS account ID (used for ECR push). |
| `prefix` | `string` | n/a | Naming prefix. |
| `project_name` | `string` | n/a | Project identifier. |
| `environment` | `string` | n/a | Environment label. |
| `vpc_id` | `string` | n/a | VPC hosting the service. |
| `service_subnet_ids` | `list(string)` | n/a | Subnets for Fargate tasks (private). |
| `alb_subnet_ids` | `list(string)` | n/a | Public subnets for the ALB. |
| `repository_name` | `string` | n/a | Base name for the ECR repository. |
| `image_scanning_configuration` | `bool` | `true` | Enable image scan-on-push. |
| `image_tag_mutability` | `string` | `"MUTABLE"` | ECR tag mutability setting. |
| `keep_last_n_images` | `number` | `10` | Number of images retained via lifecycle policy. |
| `app_version` | `string` | `"1.0.0"` | Tag applied to the built image (used in null-resource trigger). |
| `container_insights` | `string` | `"enabled"` | ECS cluster Container Insights toggle. |
| `desired_count` | `number` | `1` | Desired number of service tasks. |
| `task_execution_role_arn` | `string` | `""` | IAM role for pulling images/logging (optional). |
| `log_retention_in_days` | `number` | `14` | CloudWatch log retention. |
| `log_stream_prefix` | `string` | `"app"` | Prefix for log streams. |

## Outputs
| Name | Description |
|------|-------------|
| `repository_name` / `repository_url` / `repository_arn` | ECR repository identifiers. |
| `cluster_id` / `cluster_arn` | ECS cluster identifiers. |
| `service_name` / `service_arn` | ECS service identifiers. |
| `service_security_group_id` | Security group shielding the service ENIs. |
| `alb_arn` / `alb_dns_name` | Application Load Balancer identifiers. |
| `target_group_arn` | Target group fronting the service. |
| `task_definition_arn` | Active task definition ARN. |
| `log_group_name` | CloudWatch Logs group capturing application output. |

## Environment Variables
- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN` (if using temporary credentials) – required for the `local-exec` Docker/ECR login.
- Docker CLI must be available on the host running Terraform for the build/push step.

## Notes
- The `null_resource.build_and_push_image` rebuilds whenever `app_version` changes; bump it as part of release workflows.
- Customize application code under `modules/ecs/app/` to change the container image content.
- If you prefer CI-driven images, remove the null resource and supply image URIs via variables instead.
