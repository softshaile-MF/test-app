# Test-App Website

Publishes web content using S3.

## Prerequisites

* AWS account
* Terraform
* Added precommit with hooks

# Overview

Static Website hosted on S3 service

# Website

Creates an S3 bucket for storing the website files. Utilised "github.com/terraform-aws-modules/terraform-aws-s3-bucket" module .

# Website Hosting Configuration

The aws_s3_bucket_website resource block enables website hosting for the S3 bucket created above. It specifies the default index document and error document to use when a user requests the root URL of the bucket and encounters an error, respectively.

# IAM Policies and Users

The script creates three IAM policies to allow different groups of users to access and modify the website files in different ways. The policies are defined using JSON-encoded strings that specify a set of statements, each containing an effect (either "Allow" or "Deny"), a list of actions, and a list of resources.

# Marketing Policy

The aws_iam_policy.marketing_policy resource block creates an IAM policy that allows users to read and write to the entire S3 bucket, but only if the objects are marked with a public-read ACL.

# Content Editor Policy

The aws_iam_policy.content_editor_policy resource block creates an IAM policy that allows users to read and write to the entire S3 bucket.

---

## Requirements

| Name | Version |
|------|---------|
|  [terraform](#requirement\_terraform) | >= 1.3.0 |
|  [aws](#requirement\_aws) | ~> 4.64.0 |

## Providers

| Name | Version |
|------|---------|
|  [aws](#provider\_aws) | 4.64.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_group.content-editors-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_group.hr-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_group.marketing-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_group_membership.content-editors-group-membership](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_membership) | resource |
| [aws_iam_group_membership.hr-group-membership](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_membership) | resource |
| [aws_iam_group_membership.marketing-group-membership](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_membership) | resource |
| [aws_iam_group_policy.content-editors-group-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy) | resource |
| [aws_iam_group_policy.hr-group-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy) | resource |
| [aws_iam_group_policy.marketing-group-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy) | resource |
| [aws_iam_user.content-editor-user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.hr-user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.marketing-users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_s3_bucket.static-site-bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.static-site-bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_ownership_controls.static-site-bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.static-site-bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.static-site-bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.encrypt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.static-site-bucket-versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_website_configuration.static-site-config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_s3_object.static-site-objects](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_iam_policy_document.all-access-to-bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.hr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.marketing-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.static-site-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
|  [bucket\_name](#input\_bucket\_name) | S3 static site domain name | `string` | `"s3-static-app-240042023"` | no |
|  [marketing-users](#input\_marketing-users) | n/a | `list(string)` | [  "Alice",  "Malory"] | no |
|  [region](#input\_region) | n/a | `string` | `"us-east-1"` | no |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name | Version |
|------|---------|
|  [terraform](#requirement\_terraform) | >= 1.3.0 |
|  [aws](#requirement\_aws) | ~> 4.64.0 |

## Providers

| Name | Version |
|------|---------|
|  [aws](#provider\_aws) | 4.64.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
|  [s3\_bucket](#module\_s3\_bucket) | terraform-aws-modules/s3-bucket/aws | 3.8.2 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.s3_distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_iam_group.content-editors-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_group.hr-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_group.marketing-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_group_membership.content-editors-group-membership](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_membership) | resource |
| [aws_iam_group_membership.hr-group-membership](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_membership) | resource |
| [aws_iam_group_membership.marketing-group-membership](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_membership) | resource |
| [aws_iam_group_policy.content-editors-group-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy) | resource |
| [aws_iam_group_policy.hr-group-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy) | resource |
| [aws_iam_group_policy.marketing-group-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy) | resource |
| [aws_iam_user.content-editor-user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.hr-user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.marketing-users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_s3_bucket_policy.static-site-bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_object.static-site-objects](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_iam_policy_document.all-access-to-bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.hr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.marketing-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.static-site-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
|  [bucket\_name](#input\_bucket\_name) | S3 static site domain name | `string` | `"s3-static-app-250042023"` | no |
|  [marketing-users](#input\_marketing-users) | n/a | `list(string)` | [  "Alice",  "Malory"] | no |
|  [region](#input\_region) | n/a | `string` | `"us-east-1"` | no |
|  [terraform-state](#input\_terraform-state) | terraform s3 state | `string` | `"staticwebsite-terraform"` | no |

## Outputs

| Name | Description |
|------|-------------|
|  [cloudfront-distribution](#output\_cloudfront-distribution) | n/a |
|  [s3\_bucket\_name](#output\_s3\_bucket\_name) | Name of of website bucket |
|  [s3\_bucket\_website\_endpoint](#output\_s3\_bucket\_website\_endpoint) | Website endpoint for the S3 bucket |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
