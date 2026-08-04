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
