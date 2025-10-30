# Module: EC2 Bastion

Provision an SSH bastion host along with its key pair, security group, and
optional Elastic IP, providing secure ingress into private subnets.

## Features
- Imports an existing public key from `keypair/<key_name>.pub` and registers it in EC2.
- Launches an Amazon Linux bastion instance with configurable AMI and instance type.
- Creates security group rules for SSH plus optional extra TCP ports.
- Optionally associates an Elastic IP for stable public access.

## Usage
```hcl
module "bastion" {
  source = "../../modules/ec2"

  prefix       = var.prefix
  project_name = var.project_name
  environment  = var.environment

  region    = var.region
  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnet_ids[0]

  instance_name         = "bastion"
  instance_type         = var.bastion_instance_type
  key_name              = var.bastion_key_name
  instance_profile_name = module.iam.poweruser_instance_profile_name
}
```

## Inputs
| Name | Type | Default | Description |
|------|------|---------|-------------|
| `prefix` | `string` | n/a | Resource naming prefix. |
| `project_name` | `string` | n/a | Project identifier used in tags. |
| `environment` | `string` | n/a | Environment label (dev, prod, etc.). |
| `region` | `string` | n/a | AWS region hosting the instance. |
| `vpc_id` | `string` | n/a | VPC where the instance is launched. |
| `subnet_id` | `string` | n/a | Subnet (usually public) used by the bastion. |
| `ami` | `string` | `amazon_linux_2023` | AMI ID or alias. Supports `amazon_linux_2` / `amazon_linux_2023` shortcuts. |
| `instance_name` | `string` | n/a | Logical name appended to resource tags. |
| `instance_type` | `string` | n/a | EC2 instance size. |
| `key_name` | `string` | n/a | Key pair name; `.pub` must exist under `keypair/`. |
| `allocate_eip` | `bool` | `true` | Whether to create and attach an Elastic IP. |
| `ssh_port` | `number` | `22` | SSH listening port. |
| `allowed_ports` | `list(number)` | `[]` | Extra TCP ports to open inbound from the Internet. |
| `additional_sgs` | `list(string)` | `[]` | Additional security groups attached to the instance. |
| `instance_profile_name` | `string` | n/a | IAM instance profile to attach. |

## Outputs
| Name | Description |
|------|-------------|
| `instance_id` | EC2 instance identifier. |
| `instance_private_ip` | Private IPv4 address. |
| `instance_public_ip` | Public IPv4 (Elastic IP if allocated, otherwise instance public IP). |
| `instance_public_dns` | Public DNS hostname. |
| `security_group_id` | ID of the bastion security group. |
| `key_pair_name` | Name of the registered EC2 key pair. |
| `elastic_ip_allocation_id` | Allocation ID for the EIP when `allocate_eip = true`. |

## Environment Variables
None. Ensure AWS credentials allow importing key pairs and launching instances.

## Notes
- Place the public key file at `keypair/<key_name>.pub` before applying.
- To avoid exposing SSH to the world, restrict `allowed_ports`/`ssh_port` or update security group rules after provisioning.
