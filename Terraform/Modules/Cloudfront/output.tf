output "distribution_id" {
  value       = aws_cloudfront_distribution.this.id
  description = "CloudFront distribution ID"
}

output "distribution_arn" {
  value       = aws_cloudfront_distribution.this.arn
  description = "CloudFront distribution ARN"
}

output "domain_name" {
  value       = aws_cloudfront_distribution.this.domain_name
  description = "CloudFront domain name (dxxxx.cloudfront.net)"
}

output "hosted_zone_id" {
  value       = aws_cloudfront_distribution.this.hosted_zone_id
  description = "Hosted zone ID to use for Route 53 ALIAS records"
}

output "vpc_origin_id" {
  description = "VPC Origin ID"
  value       = aws_cloudfront_vpc_origin.alb.id
}
