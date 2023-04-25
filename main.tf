## S3 bucket for static website
resource "aws_s3_bucket" "static-site-bucket" {
  bucket = var.bucket_name
  #checkov:skip=CKV2_AWS_62: "Ensure S3 buckets should have event notifications enabled"
  #checkov:skip=CKV2_AWS_61: "Ensure that an S3 bucket has a lifecycle configuration"
  #checkov:skip=CKV2_AWS_62: "Ensure S3 buckets should have event notifications enabled"
  #checkov:skip=CKV_AWS_20: "S3 Bucket has an ACL defined which allows public READ access."
  #checkov:skip=CKV_AWS_18: "Ensure the S3 bucket has access logging enabled"
  #checkov:skip=CKV2_AWS_6: "Ensure that S3 bucket has a Public Access block"
  #checkov:skip=CKV_AWS_145: "Ensure that S3 buckets are encrypted with KMS by default"
  #checkov:skip=CKV_AWS_144: "Ensure that S3 bucket has cross-region replication enabled"
}

resource "aws_s3_bucket_versioning" "static-site-bucket-versioning" {
  bucket = aws_s3_bucket.static-site-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

## S3 bucket configuration related to ownership
resource "aws_s3_bucket_ownership_controls" "static-site-bucket" {
  bucket = aws_s3_bucket.static-site-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

## S3 bucket configuration related to access
resource "aws_s3_bucket_public_access_block" "static-site-bucket" {
  bucket = aws_s3_bucket.static-site-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
  #checkov:skip=CKV_AWS_53: "Ensure S3 bucket has block public ACLS enabled"
  #checkov:skip=CKV_AWS_54: "Ensure S3 bucket has block public ACLS enabled"
  #checkov:skip=CKV_AWS_55: "Ensure S3 bucket has ignore public ACLs enabled"
  #checkov:skip=CKV_AWS_56: "Ensure S3 bucket has 'restrict_public_bucket' enabled"
}

## S3 bucket acl configuration
resource "aws_s3_bucket_acl" "static-site-bucket" {
  depends_on = [
    aws_s3_bucket_ownership_controls.static-site-bucket,
    aws_s3_bucket_public_access_block.static-site-bucket,
  ]

  bucket = aws_s3_bucket.static-site-bucket.id
  acl    = "public-read"
}

## S3 bucket policy setup based on the policy document.
resource "aws_s3_bucket_policy" "static-site-bucket" {
  bucket = aws_s3_bucket.static-site-bucket.id
  policy = data.aws_iam_policy_document.static-site-policy.json
}

## Upload static object contents
resource "aws_s3_object" "static-site-objects" {
  for_each     = fileset("${path.module}/tech-test", "**/*.html")
  bucket       = aws_s3_bucket.static-site-bucket.id
  key          = each.value
  source       = "${path.module}/tech-test/${each.value}"
  content_type = "text/html"
}

## Static website related configuraiton
resource "aws_s3_bucket_website_configuration" "static-site-config" {
  bucket = aws_s3_bucket.static-site-bucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

/* locals {
  s3_origin_id = "myS3Origin"
} */

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt" {
  bucket = aws_s3_bucket.static-site-bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


## Setting up the marketing users
resource "aws_iam_user" "marketing-users" {
  count = length(var.marketing-users)
  name  = var.marketing-users[count.index]
  #checkov:skip=CKV_AWS_273: "Ensure access is controlled through SSO and not AWS IAM defined users"
}

## Setting up the marketing group
resource "aws_iam_group" "marketing-group" {
  name = "Marketing"
}



## Setting up the group level policy
resource "aws_iam_group_policy" "marketing-group-policy" {
  name   = "MarketingS3Policy"
  group  = aws_iam_group.marketing-group.name
  policy = data.aws_iam_policy_document.marketing-policy.json
}


## Setting up the group and user relationship
resource "aws_iam_group_membership" "marketing-group-membership" {
  name  = "marketing-group-membership"
  count = length(aws_iam_user.marketing-users)
  users = [
    aws_iam_user.marketing-users[0].name,
    aws_iam_user.marketing-users[1].name
  ]
  group = aws_iam_group.marketing-group.name
}

## Setting up the content editor user
resource "aws_iam_user" "content-editor-user" {
  name = "Bobby"
  #checkov:skip=CKV_AWS_273: "Ensure access is controlled through SSO and not AWS IAM defined users"
}

## Setting up the content editors group
resource "aws_iam_group" "content-editors-group" {
  name = "ContentEditors"
}

## Setting up the group level policy
resource "aws_iam_group_policy" "content-editors-group-policy" {
  name   = "ContentEditorsS3Policy"
  group  = aws_iam_group.content-editors-group.name
  policy = data.aws_iam_policy_document.all-access-to-bucket.json
}

## Setting up the group and user relationship
resource "aws_iam_group_membership" "content-editors-group-membership" {
  name = "content-editors-membership"
  users = [
    aws_iam_user.content-editor-user.name,
  ]
  group = aws_iam_group.content-editors-group.name
}



## Setting up the hr user
resource "aws_iam_user" "hr-user" {
  name = "Charlie"
  #checkov:skip=CKV_AWS_273: "Ensure access is controlled through SSO and not AWS IAM defined users"
}

resource "aws_iam_group" "hr-group" {
  name = "HR"
}

resource "aws_iam_group_membership" "hr-group-membership" {
  name = "hr-membership"
  users = [
    aws_iam_user.hr-user.name,
  ]
  group = aws_iam_group.hr-group.name
}

resource "aws_iam_group_policy" "hr-group-policy" {
  name   = "HRS3Policy"
  group  = aws_iam_group.hr-group.name
  policy = data.aws_iam_policy_document.hr.json
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.static-site-bucket.bucket_regional_domain_name
    origin_id   = var.bucket_name
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  custom_error_response {
    error_code         = "404"
    response_page_path = "/error.html"
    response_code      = "404"
  }
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.bucket_name

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}