resource "aws_cloudfront_vpc_origin" "alb" {
  vpc_origin_endpoint_config {
    name                   = "english-somali-dictionary-vpc-origin"
    arn                    = var.alb_arn
    http_port              = 80
    https_port             = 443
    origin_protocol_policy = "https-only"

    origin_ssl_protocols {
      items    = ["TLSv1.2"]
      quantity = 1
    }
  }
}

# tfsec:ignore:AVD-AWS-0010  # Logging for distribution not enabled intentional for this module
#tfsec:ignore:AVD-AWS-0011 because: WAF ARN is supplied by root module
resource "aws_cloudfront_distribution" "this" {
  enabled         = true
  is_ipv6_enabled = true
  comment         = "English Somali Dictionary App CloudFront"
  aliases         = var.aliases
  price_class     = var.price_class
  web_acl_id      = var.waf_acl

  origin {
    domain_name = var.domain_name
    origin_id   = "vpc-origin"

    vpc_origin_config {
      vpc_origin_id = aws_cloudfront_vpc_origin.alb.id
    }
  }

  default_cache_behavior {
    target_origin_id       = "vpc-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "PATCH", "POST", "DELETE"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]

    # Use custom cache policy with configurable TTL
    cache_policy_id = aws_cloudfront_cache_policy.custom.id

    # Use AWS Managed Origin Request Policy to forward all viewer requests
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3" # Managed-AllViewer
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction { restriction_type = "none" }
  }

  depends_on = [aws_cloudfront_vpc_origin.alb]
}

# Custom cache policy with configurable TTL
resource "aws_cloudfront_cache_policy" "custom" {
  name    = "dictionary-cache-policy"
  comment = "Custom cache policy for dictionary API"

  default_ttl = var.default_ttl
  max_ttl     = var.max_ttl
  min_ttl     = var.min_ttl

  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true

    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "all" # Include query strings in cache key
    }
  }
}
