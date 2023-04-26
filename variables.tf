variable "region" {
  type    = string
}

variable "bucket_name" {
  description = "S3 static site domain name"
  type        = string
}

variable "marketing-users" {
  type    = list(string)
}
