locals {
    ami = (
      var.ami == "amazon_linux_2"    ? data.aws_ami.amazon_linux_2.id :
      var.ami == "amazon_linux_2023" ? data.aws_ami.amazon_linux_2023.id :
      var.ami
    )

    keyfile = file("${path.root}/../../keypair/${var.key_name}.pub")

    userdata = templatefile("${path.module}/scripts/user-data.sh", {
        ssh_port = var.ssh_port
    })
}

### --------------------------------------------------
### Keypair and Elastic IP
### --------------------------------------------------
resource "aws_key_pair" "main" {
    key_name = var.key_name
    public_key = local.keyfile

    tags = {
        Name = "${var.prefix}-${var.project_name}-${var.environment}-${var.key_name}"
    }
}

resource "aws_eip" "main" {
    count = var.allocate_eip ? 1 : 0
    domain = "vpc"

    tags = {
        Name = "${var.prefix}-${var.project_name}-${var.environment}-${var.instance_name}-eip"
    }
}

### --------------------------------------------------
### EC2 Instance
### --------------------------------------------------
resource "aws_instance" "main" {
    ami = local.ami
    instance_type = var.instance_type
    key_name = aws_key_pair.main.key_name
    vpc_security_group_ids = concat([ aws_security_group.main.id ], var.additional_sgs)
    subnet_id = var.subnet_id
    user_data = local.userdata
    iam_instance_profile = var.instance_profile_name

    tags = {
        Name = "${var.prefix}-${var.project_name}-${var.environment}-${var.instance_name}"
    }

    depends_on = [ aws_key_pair.main, aws_eip.main, aws_security_group.main ]
}

resource "aws_eip_association" "main" {
    count = var.allocate_eip ? 1 : 0
    instance_id = aws_instance.main.id
    allocation_id = aws_eip.main[0].id
}

### --------------------------------------------------
### Security Group
### --------------------------------------------------
resource "aws_security_group" "main" {
    name = "${var.prefix}-${var.project_name}-${var.environment}-${var.key_name}"
    description = "Security group for the EC2 instance"
    vpc_id = var.vpc_id

    ingress {
        from_port = var.ssh_port
        to_port = var.ssh_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    dynamic "ingress" {
        for_each = var.allowed_ports
        content {
            from_port = each.value
            to_port = each.value
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.prefix}-${var.project_name}-${var.environment}-${var.key_name}"
    }
}