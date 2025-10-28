data "aws_availability_zones" "available" {
  state = "available"
}

locals {
    # Get all Availability zones (A, B, C, D is avail for Seoul)
    azs = data.aws_availability_zones.available.names

    # Get the CIDR prefix of the VPC
    vpc_cidr_prefix = tonumber(split("/", var.vpc_cidr)[1])
    subnet_newbits = 24 - local.vpc_cidr_prefix # Get a newbits to calculate subnet cidrs

    # Calculate public subnet cidrs (xxx.xxx.1/2/3.xxx)
    public_subnet_cidrs = [
        for i in range(length(local.azs)):
            cidrsubnet(var.vpc_cidr, local.subnet_newbits, i + 1)
    ]

    # Calculate private subnet cidrs (xxx.xxx.11/12/13.xxx)
    private_subnet_cidrs = [
        for i in range(length(local.azs)):
            cidrsubnet(var.vpc_cidr, local.subnet_newbits, i + 11)
    ]
}

### --------------------------------------------------
### AWS VPC
### --------------------------------------------------
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr

    enable_dns_hostnames = true
    enable_dns_support = true
    enable_network_address_usage_metrics = true
    
    tags = {
        Name = "${var.prefix}-${var.project_name}-${var.environment}-vpc"
    }
}

### --------------------------------------------------
### AWS Subnets
### --------------------------------------------------
resource "aws_subnet" "public" {
    count = length(local.azs)
    vpc_id = aws_vpc.main.id
    cidr_block = local.public_subnet_cidrs[count.index]
    availability_zone = element(local.azs, count.index)
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.prefix}-${var.project_name}-${var.environment}-public-subnet-${element(local.azs, count.index)}"
    }
}

resource "aws_subnet" "private" {
    count = length(local.azs)
    vpc_id = aws_vpc.main.id
    cidr_block = local.private_subnet_cidrs[count.index]
    availability_zone = element(local.azs, count.index)

    tags = {
        Name = "${var.prefix}-${var.project_name}-${var.environment}-private-subnet-${element(local.azs, count.index)}"
    }
}

### --------------------------------------------------
### Routing Tables & Routes
### --------------------------------------------------
# Public Route Table (used by 4 public subnets)
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "${var.prefix}-${var.project_name}-${var.environment}-public-route-table"
    }
}

resource "aws_route_table_association" "public" {
    count = length(local.azs)
    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
}

resource "aws_route" "public" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
    
    depends_on = [ aws_internet_gateway.main ]
}

# Create Private rtb per AZ
resource "aws_route_table" "private" {
    count = length(local.azs)
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "${var.prefix}-${var.project_name}-${var.environment}-private-route-table-${element(local.azs, count.index)}"
    }
}

resource "aws_route_table_association" "private" {
    count = length(local.azs)
    subnet_id = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route" "private" {
    count = length(local.azs)
    route_table_id = aws_route_table.private[count.index].id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id

    depends_on = [ aws_nat_gateway.main ]
}

### --------------------------------------------------
### Gateways
### --------------------------------------------------
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
    
    tags = {
        Name = "${var.prefix}-${var.project_name}-${var.environment}-igw"
    }
}

# Create EIP per AZ
resource "aws_eip" "nat" {
    count = length(local.azs)
    domain = "vpc"

    tags = {
        Name = "${var.prefix}-${var.project_name}-${var.environment}-nat-eip-${element(local.azs, count.index)}"
    }
}

# Create NAT gateway per AZ
resource "aws_nat_gateway" "main" {
    count = length(local.azs)
    subnet_id = aws_subnet.public[count.index].id
    allocation_id = aws_eip.nat[count.index].id

    tags = {
        Name = "${var.prefix}-${var.project_name}-${var.environment}-nat-gateway-${element(local.azs, count.index)}"
    }
}