terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "group1-prod-terraform-state1112"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"
  }
}
