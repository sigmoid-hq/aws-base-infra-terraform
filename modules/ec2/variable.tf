variable "prefix" {
    description = "Prefix for the resources"
    type = string
}

variable "project_name" {
    description = "Project name"
    type = string
}

variable "environment" {
    description = "Environment"
    type = string
}

variable "region" {
    description = "Region"
    type = string
}

variable "vpc_id" {
    description = "VPC ID"
    type = string
}

variable "subnet_id" {
    description = "Subnet ID"
    type = string
}

variable "ami" {
    description = "AMI"
    type = string
    default = "amazon_linux_2023"

    validation {
        condition = contains(["amazon_linux_2", "amazon_linux_2023"], var.ami)
        error_message = "AMI must be one of: amazon_linux_2, amazon_linux_2023"
    }
}

variable "instance_name" {
    description = "Instance name"
    type = string
}

variable "instance_type" {
    description = "Instance type"
    type = string
}

variable "key_name" {
    description = "Key pair name"
    type = string
}

variable "allocate_eip" {
    description = "Allocate Elastic IP"
    type = bool
    default = true
}

variable "ssh_port" {
    description = "Bastion port"
    type = number
    default = 22

    validation {
        condition = var.ssh_port >= 1 && var.ssh_port <= 65535
        error_message = "Bastion port must be between 1 and 65535"
    }
}

variable "allowed_ports" {
    description = "Allowed ports"
    type = list(number)
    default = []

    validation {
        condition = alltrue([for port in var.allowed_ports : port >= 1 && port <= 65535])
        error_message = "Allowed ports must be between 1 and 65535"
    }
}

variable "additional_sgs" {
    description = "Additional security groups"
    type = list(string)
    default = []
}

variable "instance_profile_name" {
    description = "Instance profile name"
    type = string
}