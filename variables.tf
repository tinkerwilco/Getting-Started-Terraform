variable "naming_prefix" {
  type        = string
  description = "Naming prefix for all resources"
  default     = "hustlrweb"
}

variable "aws_region" {
  type        = string
  description = "AWS Region to use for resources"
  default     = "us-east-1"
}

## see comments below for previous implementation without workspaces
variable "vpc_cidr_block" {
  type        = map(string)
  description = "AWS VPC CIDR block"
}

variable "vpc_subnet_count" {
  type        = map(number)
  description = "Number of subnets to create"
}

variable "aws_instance_count" {
  type        = map(number)
  description = "Number of instances to create in AWS"
}

variable "aws_instance_type" {
  type        = map(string)
  description = "AWS instance type to deploy in EC2"
}

## variables before terraform.workspace implementation
# variable "vpc_cidr_block" {
#   type        = string
#   description = "AWS VPC CIDR block"
#   default     = "10.0.0.0/16"
# }

# variable "vpc_subnet_count" {
#   type        = number
#   description = "Number of subnets to create"
#   default     = 2
# }

# variable "aws_instance_count" {
#   type        = number
#   description = "Number of instances to create in AWS"
#   default     = 4
# }

# variable "aws_instance_type" {
#   type        = string
#   description = "AWS instance type to deploy in EC2"
#   default     = "t2.micro"
# }

# replaced by cidrsubnet function and vpc module
# variable "vpc_subnets_cidr_block" {
#   type        = list(string)
#   description = "AWS Subnets CIDR block"
#   default     = ["10.0.0.0/24", "10.0.1.0/24"]
# }

variable "enable_dns_hostnames" {
  type        = string
  description = "Enable DNS hostnames in VPC"
  default     = true
}

variable "map_public_ip_on_launch" {
  type        = string
  description = "Map a public IP address for Subnet instances"
  default     = true
}

variable "company" {
  type        = string
  description = "Company name for resource tagging"
  default     = "Hustlrmantics"
}

variable "project" {
  type        = string
  description = "Project name for resource tagging"
}

variable "billing_code" {
  type        = string
  description = "Billing code for resource tagging"
}