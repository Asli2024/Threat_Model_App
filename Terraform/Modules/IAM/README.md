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
| [aws_iam_policy.custom](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.custom_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.managed](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assume_role_policy"></a> [assume\_role\_policy](#input\_assume\_role\_policy) | The policy that grants an entity permission to assume the role | `string` | `""` | no |
| <a name="input_create_custom_policy"></a> [create\_custom\_policy](#input\_create\_custom\_policy) | Whether to create a custom IAM policy | `bool` | `false` | no |
| <a name="input_custom_policy_document"></a> [custom\_policy\_document](#input\_custom\_policy\_document) | IAM policy document for the custom policy (JSON string or data source output) | `string` | `""` | no |
| <a name="input_custom_policy_name"></a> [custom\_policy\_name](#input\_custom\_policy\_name) | Name for the custom IAM policy | `string` | `""` | no |
| <a name="input_managed_policy_arns"></a> [managed\_policy\_arns](#input\_managed\_policy\_arns) | A list of ARNs of IAM managed policies to attach | `list(string)` | `[]` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | The name of the IAM role | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | The ARN of the IAM role |
| <a name="output_role_id"></a> [role\_id](#output\_role\_id) | The stable and unique string identifying the role |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | The name of the IAM role |
<!-- END_TF_DOCS -->
