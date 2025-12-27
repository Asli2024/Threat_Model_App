data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_ec2_managed_prefix_list" "cf_origin" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

data "aws_acm_certificate" "cloudfront_cert" {
  provider    = aws.use1
  domain      = "techwithaden.com"
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_ecr_image" "app_image" {
  repository_name = "english-somali-dictionary-app-ecr-repo"
  most_recent     = true
}
