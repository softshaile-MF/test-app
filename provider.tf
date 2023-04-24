terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
       version = "~> 4.64.0"
    }
  }

  required_version = ">= 1.3.0"
}

provider "aws" {
  region     = "us-east-1"
  profile = "aws-terraform-profile"
}
