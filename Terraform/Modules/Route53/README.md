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
| [aws_route53_record.alias](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/route53_record) | resource |
| [aws_route53_record.delegate_subdomain_ns](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/route53_record) | resource |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/route53_zone) | resource |
| [aws_route53_zone.parent](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_name"></a> [dns\_name](#input\_dns\_name) | ALB DNS name (e.g., myalb-123.eu-west-2.elb.amazonaws.com) | `string` | `""` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | FQDN of the hosted zone to create (e.g., dev.techwithaden.com or techwithaden.com) | `string` | `""` | no |
| <a name="input_evaluate_target_health"></a> [evaluate\_target\_health](#input\_evaluate\_target\_health) | Whether Route 53 should evaluate target health for the ALIAS | `bool` | `false` | no |
| <a name="input_parent_domain_name"></a> [parent\_domain\_name](#input\_parent\_domain\_name) | Existing parent zone to delegate from (e.g., techwithaden.com). Must exist in Route 53. | `string` | `""` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | ALB hosted zone ID (from aws\_lb.zone\_id) | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alias_fqdn"></a> [alias\_fqdn](#output\_alias\_fqdn) | FQDN of the created A (ALIAS) record |
| <a name="output_delegation_record_name"></a> [delegation\_record\_name](#output\_delegation\_record\_name) | Name of the NS delegation record created in the parent zone |
| <a name="output_hosted_zone_id"></a> [hosted\_zone\_id](#output\_hosted\_zone\_id) | ID of the created hosted zone |
| <a name="output_name_servers"></a> [name\_servers](#output\_name\_servers) | Nameservers for the created hosted zone (use for delegation) |
| <a name="output_zone_name"></a> [zone\_name](#output\_zone\_name) | Name of the created hosted zone |
<!-- END_TF_DOCS -->
