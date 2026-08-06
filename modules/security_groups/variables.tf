variable "env" {
  description = "Environment name"
  type        = string
}

variable "group_name" {
  description = "Group name for resource tagging"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to create security groups in"
  type        = string
}
