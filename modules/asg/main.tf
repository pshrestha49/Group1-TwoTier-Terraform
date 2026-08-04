resource "aws_autoscaling_group" "web" {

  min_size = var.min_size

  max_size = var.max_size

  desired_capacity = var.desired_capacity

  vpc_zone_identifier = var.private_subnets

  target_group_arns = [
    var.target_group_arn
  ]

  launch_template {
    id = var.launch_template_id
    version = "$Latest"
  }

}