## S3 bucket for static website
module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.8.2"

  bucket                   = var.bucket_name
  control_object_ownership = true
  acl                      = "public-read"

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  website = {
    index_document = "index.html"
    error_document = "error.html"
  }
}


## S3 bucket policy setup based on the policy document.
resource "aws_s3_bucket_policy" "static-site-bucket" {
  /* bucket = aws_s3_bucket.static-site-bucket.id */
  bucket = module.s3_bucket.s3_bucket_id
  policy = data.aws_iam_policy_document.static-site-policy.json
}

## Upload static object contents
resource "aws_s3_object" "static-site-objects" {
  for_each     = fileset("${path.module}/tech-test", "**/*.html")
  bucket       = module.s3_bucket.s3_bucket_id
  key          = each.value
  source       = "${path.module}/tech-test/${each.value}"
  content_type = "text/html"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = module.s3_bucket.s3_bucket_bucket_regional_domain_name
    origin_id   = module.s3_bucket.s3_bucket_id
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
    target_origin_id = module.s3_bucket.s3_bucket_id

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
