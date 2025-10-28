# Amazon Linux 2
data "aws_ami" "amazon_linux_2" {
    most_recent = true
    owners = ["amazon"]

    filter {
        name = "name"
        values = ["amzn2-ami-*"]
    }

    filter {
        name = "architecture"
        values = ["x86_64"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}

# Amazon Linux 2023
data "aws_ami" "amazon_linux_2023" {
    most_recent = true
    owners = ["amazon"]

    filter {
        name = "name"
        values = ["amzn2023-ami-*"]
    }

    filter {
        name = "architecture"
        values = ["x86_64"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}

# Ubuntu 24.04
data "aws_ami" "ubuntu_24_04" {
    most_recent = true
    owners = ["099720109477"]

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-24.04-amd64-server-*"]
    }
}