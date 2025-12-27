output "id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.this.id
}

output "arn" {
  description = "CloudFront distribution ARN"
  value       = aws_cloudfront_distribution.this.arn
}

output "domain_name" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.this.domain_name
}

output "hosted_zone_id" {
  description = "CloudFront hosted zone ID (for Route53 alias records)"
  value       = aws_cloudfront_distribution.this.hosted_zone_id
}

output "vpc_origin_id" {
  description = "CloudFront VPC origin ID"
  value       = aws_cloudfront_vpc_origin.alb.id
}
