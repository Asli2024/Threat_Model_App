variable "alb_arn" {
  description = "ARN of the ALB to expose via CloudFront VPC origin"
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

variable "default_ttl" {
  description = "Default TTL (seconds)"
  type        = number
  default     = 3600
}

variable "max_ttl" {
  description = "Max TTL (seconds)"
  type        = number
  default     = 86400
}

variable "min_ttl" {
  description = "Min TTL (seconds)"
  type        = number
  default     = 0
}

variable "domain_name" {
  description = "Domain name for the CloudFront distribution"
  type        = string
}

variable "waf_acl" {
  description = "The ID of the WAF to associate with the CloudFront distribution"
  type        = string
  default     = ""
}
