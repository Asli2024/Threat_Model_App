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
| [aws_wafv2_web_acl.this](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/wafv2_web_acl) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Description for the WAFv2 Web ACL | `string` | `"Web ACL for English Somali Dictionary Application"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the WAFv2 Web ACL and metric | `string` | `"EnglishSomaliDictionaryWebACL"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_waf_arn"></a> [waf\_arn](#output\_waf\_arn) | The ARN of the WAF |
| <a name="output_waf_id"></a> [waf\_id](#output\_waf\_id) | The ID of the WAF |
<!-- END_TF_DOCS -->
