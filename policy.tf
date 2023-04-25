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
      module.s3_bucket.s3_bucket_arn,
      "${module.s3_bucket.s3_bucket_arn}/*",
    ]
  }
}


data "aws_iam_policy_document" "marketing-policy" {
  version = "2012-10-17"
  statement {
    sid    = "BucketList"
    effect = "Allow"
    actions = [
      "s3:ListAllMyBuckets",
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    sid    = "S3Upload"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::${var.bucket_name}/news/*"
    ]
  }

}

data "aws_iam_policy_document" "all-access-to-bucket" {
  version = "2012-10-17"
  statement {
    sid    = "BucketList"
    effect = "Allow"
    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
      "s3:GetBucketVersioning"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    sid    = "AllowAllInBucket"
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = [
      "arn:aws:s3:::${var.bucket_name}/*"
    ]
  }
}

data "aws_iam_policy_document" "hr" {
  version = "2012-10-17"
  statement {
    sid    = "BucketList"
    effect = "Allow"
    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
      "s3:ListBucket",
    ]
    resources = [
      "*"
    ]
  }
  statement {
    sid    = "AllowUserUpdatePeopleFile"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::${var.bucket_name}/people.html"
    ]
  }
}