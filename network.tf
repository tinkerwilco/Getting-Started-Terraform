##################################################################################
# DATA
##################################################################################

data "aws_availability_zones" "available" {}

##################################################################################
# RESOURCES
##################################################################################

# # NETWORKING #
# resource "aws_vpc" "vpc" {
#   cidr_block           = var.vpc_cidr_block
#   enable_dns_hostnames = var.enable_dns_hostnames

# tags = merge(local.common_tags, {
#   Name = "${local.name_prefix}-vpc"
# })
# }

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.vpc.id

#   tags = merge(local.common_tags, {
#     Name = "${local.name_prefix}-igw"
#   })
# }

# resource "aws_subnet" "subnets" {
#   count = var.vpc_subnet_count
#   # cidr_block              = var.vpc_subnets_cidr_block[count.index]
#   cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, count.index)
#   vpc_id                  = aws_vpc.vpc.id
#   map_public_ip_on_launch = var.map_public_ip_on_launch
#   availability_zone       = data.aws_availability_zones.available.names[count.index]

#   tags = merge(local.common_tags, {
#     Name = "${local.name_prefix}-subnet${count.index}"
#   })
# }

# # ROUTING #
# resource "aws_route_table" "rtb" {
#   vpc_id = aws_vpc.vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = merge(local.common_tags, {
#     Name = "${local.name_prefix}-rtb"
#   })
# }

# resource "aws_route_table_association" "rta-subnets" {
#   count          = var.vpc_subnet_count
#   subnet_id      = aws_subnet.subnets[count.index].id
#   route_table_id = aws_route_table.rtb.id
# }

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.4"

  cidr = var.vpc_cidr_block[terraform.workspace]

  azs            = slice(data.aws_availability_zones.available.names, 0, var.vpc_subnet_count[terraform.workspace])
  public_subnets = [for subnet in range(var.vpc_subnet_count[terraform.workspace]) : cidrsubnet(var.vpc_cidr_block[terraform.workspace], 8, subnet)]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-vpc"
  })
}

# SECURITY GROUPS #
# Load Balancer security group 
resource "aws_security_group" "alb_sg" {
  name   = "${local.name_prefix}_lbsg"
  vpc_id = module.vpc.vpc_id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Nginx security group 
resource "aws_security_group" "nginx_sg" {
  name   = "${local.name_prefix}_ngsg"
  vpc_id = module.vpc.vpc_id

  # HTTP access from VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block[terraform.workspace]]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}