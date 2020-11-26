terraform {
  backend "s3" {
    bucket = "excrum-backend"
    encrypt = true
    region = "eu-west-1"
    key = "prod-terraform-state/terraform.tfstate"
  }
}