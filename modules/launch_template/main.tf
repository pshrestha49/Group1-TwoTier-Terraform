resource "aws_launch_template" "web" {

  name_prefix = "WebTemplate-"

  image_id = var.ami_id

  instance_type = var.instance_type

  key_name = var.key_name

  vpc_security_group_ids = [
    var.security_group_id
  ]

  iam_instance_profile {
    name = "LabRole"
  }

  user_data = base64encode(
    file("${path.root}/../../scripts/userdata.sh")
  )

}