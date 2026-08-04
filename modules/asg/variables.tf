variable "launch_template_id" {}

variable "private_subnets" {
  type = list(string)
}

variable "target_group_arn" {}

variable "min_size" {}

variable "max_size" {}

variable "desired_capacity" {}