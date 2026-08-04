terraform {
  backend "s3" {
    bucket = "group1-staging-terraform-state"
    key    = "staging/terraform.tfstate"
    region = "us-east-1"
  }
}
