# ─── Application Load Balancer (Public Subnets) ───
resource "aws_lb" "app" {
  name               = "${var.group_name}-${var.env}-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids
  tags = { Name = "${var.group_name}-${var.env}-ALB" }
}

# ─── Target Group ───
resource "aws_lb_target_group" "web" {
  name     = "${var.group_name}-${var.env}-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = { Name = "${var.group_name}-${var.env}-TG" }
}

# ─── Listener ───
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}
