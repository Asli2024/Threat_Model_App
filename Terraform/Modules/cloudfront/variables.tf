variable "alb_arn" {
  description = "ARN of the ALB to expose via CloudFront VPC origin"
  type        = string
}

variable "domain_name" {
  description = "ALB DNS name (origin domain name) used by CloudFront"
  type        = string
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN in us-east-1 for CloudFront"
  type        = string
}

variable "aliases" {
  description = "Custom domain names (CNAMEs) served by this distribution"
  type        = list(string)
  default     = []
}

variable "price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100"
}

variable "waf_acl" {
  description = "WAF Web ACL ARN/ID to associate with the CloudFront distribution (optional)"
  type        = string
  default     = ""
}
