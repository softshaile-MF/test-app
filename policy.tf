data "aws_iam_policy_document" "static-site-policy" {
  statement {
    actions = [
      "s3:GetObject"
    ]
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    resources = [
      aws_s3_bucket.static-site-bucket.arn,
      "${aws_s3_bucket.static-site-bucket.arn}/*",
    ]
  }
}