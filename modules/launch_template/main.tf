terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_launch_template" "web_template" {

  name_prefix = "WebTemplate-"

  image_id = var.ami_id

  instance_type = var.instance_type

  key_name = var.key_name

  vpc_security_group_ids = [
    var.security_group_id
  ]

  iam_instance_profile {
    name = "LabInstanceProfile"
  }

  user_data = base64encode(
    file("${path.root}/../../scripts/userdata.sh")
  )

}