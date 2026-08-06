# ─── ALB Security Group (HTTP from internet) ───
resource "aws_security_group" "alb_sg" {
  name   = "${var.group_name}-${var.env}-ALB-SG"
  vpc_id = var.vpc_id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.group_name}-${var.env}-ALB-SG" }
}

# ─── Bastion Security Group (SSH from internet) ───
resource "aws_security_group" "bastion_sg" {
  name   = "${var.group_name}-${var.env}-Bastion-SG"
  vpc_id = var.vpc_id

  ingress {
    description = "SSH from admin"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.group_name}-${var.env}-Bastion-SG" }
}

# ─── Web Server Security Group (HTTP from ALB, SSH from Bastion ONLY) ───
resource "aws_security_group" "web_sg" {
  name   = "${var.group_name}-${var.env}-Web-SG"
  vpc_id = var.vpc_id

  ingress {
    description     = "HTTP from ALB only"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description     = "SSH from Bastion only"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.group_name}-${var.env}-Web-SG" }
}
