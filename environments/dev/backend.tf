terraform {
  backend "s3" {
    bucket = "group1-dev-images"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}
