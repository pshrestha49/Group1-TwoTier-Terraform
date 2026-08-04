variable "env" {
  description = "Environment name (Dev, Staging, Prod)"
  type        = string
}

variable "group_name" {
  description = "Group name for resource tagging"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of AZs to deploy into"
  type        = list(string)
}
