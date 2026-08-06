terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

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

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out"
  autoscaling_group_name = aws_autoscaling_group.web.name

  adjustment_type   = "ChangeInCapacity"
  scaling_adjustment = 1
  cooldown          = 300
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in"
  autoscaling_group_name = aws_autoscaling_group.web.name

  adjustment_type   = "ChangeInCapacity"
  scaling_adjustment = -1
  cooldown          = 300
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 10

  alarm_actions = [
    aws_autoscaling_policy.scale_out.arn
  ]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 5

  alarm_actions = [
    aws_autoscaling_policy.scale_in.arn
  ]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }
}

