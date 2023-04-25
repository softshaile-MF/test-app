variable "region" {
  type    = string
  default = "us-east-1"
}

variable "bucket_name" {
  description = "S3 static site domain name"
  type        = string
  default     = "s3-static-app-250042023"
}

variable "marketing-users" {
  type    = list(string)
  default = ["Alice", "Malory"]
}
variable "terraform-state" {
  description = "terraform s3 state"
  type        = string
  default     = "staticwebsite-terraform"
}
