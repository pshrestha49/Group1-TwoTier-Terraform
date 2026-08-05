terraform {
  backend "s3" {
    bucket = "group1-prod-terraform-state1112"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"
  }
}
