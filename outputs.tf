output "s3_bucket_name" {
  description = "Name of of website bucket"
  value       = module.s3_bucket.s3_bucket_id
}

output "s3_bucket_website_endpoint" {
  value       = module.s3_bucket.s3_bucket_website_endpoint
  description = "Website endpoint for the S3 bucket"
}

output "cloudfront-distribution" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}