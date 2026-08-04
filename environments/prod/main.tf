provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# ─── Your Modules (Person A) ───

module "networking" {
  source               = "../../modules/networking"
  env                  = var.env
  group_name           = var.group_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "security_groups" {
  source     = "../../modules/security_groups"
  env        = var.env
  group_name = var.group_name
  vpc_id     = module.networking.vpc_id
}

module "alb" {
  source            = "../../modules/alb"
  env               = var.env
  group_name        = var.group_name
  vpc_id            = module.networking.vpc_id
  alb_sg_id         = module.security_groups.alb_sg_id
  public_subnet_ids = module.networking.public_subnet_ids
}

# ─── Partner's Modules (Person B) — uncomment when ready ───

# module "launch_template" {
#   source          = "../../modules/launch_template"
#   env             = var.env
#   group_name      = var.group_name
#   ami_id          = data.aws_ami.amazon_linux.id
#   instance_type   = var.instance_type
#   key_name        = var.key_name
#   web_sg_id       = module.security_groups.web_sg_id
#   s3_image_bucket = var.s3_image_bucket
#   s3_image_key    = var.s3_image_key
#   team_members    = var.team_members
# }

# module "asg" {
#   source             = "../../modules/asg"
#   env                = var.env
#   group_name         = var.group_name
#   min_size           = var.min_size
#   max_size           = var.max_size
#   subnet_ids         = module.networking.private_subnet_ids
#   target_group_arn   = module.alb.target_group_arn
#   launch_template_id = module.launch_template.launch_template_id
# }
