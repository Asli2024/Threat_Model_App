<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | = 6.15.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.15.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.this](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_vpc_origin.alb](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/cloudfront_vpc_origin) | resource |
| [aws_cloudfront_cache_policy.caching_disabled](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/cloudfront_cache_policy) | data source |
| [aws_cloudfront_cache_policy.caching_optimized](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/cloudfront_cache_policy) | data source |
| [aws_cloudfront_origin_request_policy.all_viewer](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/cloudfront_origin_request_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_certificate_arn"></a> [acm\_certificate\_arn](#input\_acm\_certificate\_arn) | ACM certificate ARN in us-east-1 for CloudFront | `string` | n/a | yes |
| <a name="input_alb_arn"></a> [alb\_arn](#input\_alb\_arn) | ARN of the ALB to expose via CloudFront VPC origin | `string` | n/a | yes |
| <a name="input_aliases"></a> [aliases](#input\_aliases) | Custom domain names (CNAMEs) served by this distribution | `list(string)` | `[]` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | ALB DNS name (origin domain name) used by CloudFront | `string` | n/a | yes |
| <a name="input_price_class"></a> [price\_class](#input\_price\_class) | CloudFront price class | `string` | `"PriceClass_100"` | no |
| <a name="input_waf_acl"></a> [waf\_acl](#input\_waf\_acl) | WAF Web ACL ARN/ID to associate with the CloudFront distribution (optional) | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | CloudFront distribution ARN |
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | CloudFront distribution domain name |
| <a name="output_hosted_zone_id"></a> [hosted\_zone\_id](#output\_hosted\_zone\_id) | CloudFront hosted zone ID (for Route53 alias records) |
| <a name="output_id"></a> [id](#output\_id) | CloudFront distribution ID |
| <a name="output_vpc_origin_id"></a> [vpc\_origin\_id](#output\_vpc\_origin\_id) | CloudFront VPC origin ID |
<!-- END_TF_DOCS -->
