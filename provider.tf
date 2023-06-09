terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.64.0"
    }
  }
  backend "s3" {
    bucket         = "staticwebsite-terraform"
    key            = "test/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
    profile        = "aws-tf-profile"
  }


  required_version = ">= 1.3.0"
}

provider "aws" {
  region  = "us-east-1"
  profile = "aws-tf-profile"
}