terraform {

  backend "s3" {
    bucket = "terraform-dev-state-file"
    key = "test/terraform.tfstate"
    region = "ap-south-1"
    profile = "Chinar"
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "Chinar"
}
