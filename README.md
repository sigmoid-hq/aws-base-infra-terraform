# AWS Base Infrastructure Terraform Blueprint



---

## Introduction

This repository provisions a reusable AWS baseline using Terraform. It sets up
networking, compute, storage, and delivery components that can be promoted
across environments (`env/dev`, `env/prod`).

---
## Structure
```
.
├── env/
│   ├── dev/                  # Development workspace (providers, vars, tfvars)
│   └── prod/                 # Production workspace
├── modules/
│   ├── cloudfront/           # CDN routing for static site + `/api` traffic
│   ├── dynamodb/             # Application DynamoDB table
│   ├── ec2/                  # Bastion host module
│   ├── ecs/                  # Fargate cluster, task definition, ALB, ECR
│   ├── iam/                  # Shared IAM roles/profiles (bastion, ECS)
│   ├── rds/                  # MySQL-compatible RDS instance
│   ├── s3/                   # Static website, logs, and asset buckets
│   └── vpc/                  # VPC, subnets, NAT, routing
├── keypair/                  # SSH public keys consumed by the bastion module
├── README.md
└── terraform.*               # Shared configs / helpers
```

---
## Module Overview
| Module      | Purpose |
|-------------|---------|
| **VPC**     | Builds the network foundation with VPC, subnets, NAT gateways, routing tables, Internet Gateway, and NAT EIPs. |
| **IAM**     | Provides opinionated roles and instance profiles (power user, read-only, ECS task execution) for EC2 and ECS workloads. |
| **EC2**     | Provisions the bastion host, associated key pair, security group rules, and optional Elastic IP. |
| **S3**      | Creates three buckets: primary (artifacts/backups), static asset hosting (website), and access logs with recommended defaults. |
| **RDS**     | Launches a MySQL-compatible instance with subnet group, security group, optional parameter overrides, backups, and logging toggles. |
| **DynamoDB**| Manages an application table supporting configurable attributes, billing mode, TTL, and optional secondary indexes. |
| **ECS**     | Packages ECR repository, Fargate cluster/service, task definition, CloudWatch log group, ALB + target group, and lifecycle hooks. |
| **CloudFront** | Routes `/` traffic to the static S3 site and `/api/*` to the ECS ALB, enforcing HTTPS and appropriate caching/forwarding rules. |

---
## SSH Key Preparation
The EC2 bastion module expects a public key at `keypair/<key_name>.pub`.

```bash
# Generate a new SSH key pair
mkdir -p keypair
ssh-keygen -t ed25519 -f keypair/ec2-kp-prod -C "ops@somedomain"

# Result: keypair/ec2-kp-prod (private) & keypair/ec2-kp-prod.pub (public)
# Ensure the .pub file name matches `bastion_key_name` used in tfvars.
```

> ⚠️ Never commit private keys. Keep only the public `.pub` file in repo if
> needed.

---
## Deploying Environments
Each environment maintains its own backend, variables, and tfvars.

### 1. Configure `terraform.tfvars`
Edit the environment-specific `terraform.tfvars` and set secrets:
```hcl
# env/dev/terraform.tfvars
environment           = "dev"
project_name          = "aws-base-infra"
region                = "ap-northeast-2"
prefix                = "sigmoid"
vpc_cidr              = "10.0.0.0/16"

bastion_instance_type = "t3.small"
bastion_key_name      = "ec2-kp"

rds_engine                 = "mysql"
rds_engine_version         = "8.0.42"
rds_database_name          = "sigmoid_app"
rds_port                   = 3306
rds_parameter_group_family = "mysql8.0"
rds_master_password        = "replace-me"

ecs_repository_name      = "sigmoid-app"
ecs_image_tag_mutability = "MUTABLE"
ecs_keep_last_n_images   = 10
ecs_app_version          = "1.0.2"
```
Copy to `env/prod/terraform.tfvars` and adjust CIDR, instance types, password,
and retention values as needed.

### 2. Initialize
From the environment directory:
```bash
cd env/dev
terraform init
```
Repeat inside `env/prod` when ready.

### 3. Validate & Plan
```bash
terraform validate
terraform plan -out dev.plan
```

### 4. Apply
```bash
terraform apply dev.plan
```

### 5. Promote to Production
```bash
cd ../prod
terraform init
terraform validate
terraform plan -out prod.plan
terraform apply prod.plan
```

> ☝️ Remember to set a strong `rds_master_password` (or source it via
> environment variables / secrets manager) before applying.

---
## Useful Outputs
Both environments export key outputs such as VPC IDs, RDS endpoints, DynamoDB
ARNs, ECS ALB DNS, and the CloudFront distribution domain. Run
`terraform output` inside the environment directory to inspect.

---
## Notes
- The ECS module builds/pushes images locally via `docker` and AWS CLI; ensure
  your workstation has permissions.
- CloudFront is configured with default certs; swap for ACM if using custom
  domains.
- Update `bastion_key_name` and `terraform.tfvars` before committing to keep
  secrets out of git.
