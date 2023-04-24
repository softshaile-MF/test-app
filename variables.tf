variable "region" {
  type    = string
  default = "us-east-1"
}

variable "bucket_name" {
  description = "S3 static site domain name"
  type        = string
  default     = "s3-static-app-240042023"
}