terraform {
  backend "s3" {
    bucket = "group1-staging-terraform-state1112"
    key    = "staging/terraform.tfstate"
    region = "us-east-1"
  }
}
