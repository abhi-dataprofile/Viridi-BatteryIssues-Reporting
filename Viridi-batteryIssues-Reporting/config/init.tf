provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
  }
}

