terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "group1-staging-terraform-state1112"
    key    = "staging/terraform.tfstate"
    region = "us-east-1"
  }
}
