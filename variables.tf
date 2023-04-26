variable "region" {
  description = "AWS Region for resourcess "
  type    = string
}

variable "bucket_name" {
  description = "S3 static site domain name"
  type        = string
}

variable "marketing-users" {
  description = "List of Marketing users"
  type    = list(string)
}
