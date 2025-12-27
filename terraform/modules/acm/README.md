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
| [aws_acm_certificate.cert](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.validated](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/acm_certificate_validation) | resource |
| [aws_route53_record.cert_validation](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_ttl"></a> [dns\_ttl](#input\_dns\_ttl) | TTL for ACM DNS validation records | `number` | `60` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | FQDN for the certificate | `string` | `""` | no |
| <a name="input_subject_alternative_names"></a> [subject\_alternative\_names](#input\_subject\_alternative\_names) | Optional SANs, e.g., ["www.dev.techwithaden.com"] | `list(string)` | `[]` | no |
| <a name="input_validation_timeout"></a> [validation\_timeout](#input\_validation\_timeout) | Timeout for aws\_acm\_certificate\_validation.create | `string` | `"2h"` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | Public Route 53 hosted zone ID where DNS validation records will be created | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificate_arn"></a> [certificate\_arn](#output\_certificate\_arn) | ARN of the issued/validated ACM certificate |
<!-- END_TF_DOCS -->
