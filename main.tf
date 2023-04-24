resource "aws_s3_bucket" "static-site-bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "static-site-bucket" {
  bucket = aws_s3_bucket.static-site-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "static-site-bucket" {
  bucket = aws_s3_bucket.static-site-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "static-site-bucket" {
  depends_on = [
    aws_s3_bucket_ownership_controls.static-site-bucket,
    aws_s3_bucket_public_access_block.static-site-bucket,
  ]

  bucket = aws_s3_bucket.static-site-bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "static-site-bucket" {
  bucket = aws_s3_bucket.static-site-bucket.id
  policy = data.aws_iam_policy_document.static-site-policy.json
}

resource "aws_s3_object" "static-site-objects" {
  for_each = fileset("${path.module}/tech-test", "**/*.html")
  bucket = aws_s3_bucket.static-site-bucket.id
  key    = each.value
  source = "${path.module}/tech-test/${each.value}"
  content_type = "text/html" 
}

resource "aws_s3_bucket_website_configuration" "static-site-config" {
  bucket = aws_s3_bucket.static-site-bucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}