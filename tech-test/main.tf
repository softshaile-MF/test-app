provider "aws" {
  region     = var.region
  profile = "aws-terraform-profile"
}

resource "aws_s3_bucket" "static-site-bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_policy" "static-site-bucket" {
    bucket = aws_s3_bucket.static-site-bucket.id
    policy = data.aws_iam_policy_document.static-site-policy.json
}
