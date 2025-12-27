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
| [aws_ecr_repository.this](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.this](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/ecr_repository_policy) | resource |
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/kms_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.ecr_policy](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_key_policy](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | The waiting period before the KMS key is deleted | `number` | `7` | no |
| <a name="input_ecr_kms_key_alias_name"></a> [ecr\_kms\_key\_alias\_name](#input\_ecr\_kms\_key\_alias\_name) | The alias name for the KMS key used for ECR encryption (must start with alias/) | `string` | `"alias/ecr-repository-kms-keys"` | no |
| <a name="input_image_tag_mutability"></a> [image\_tag\_mutability](#input\_image\_tag\_mutability) | The tag mutability setting for the repository | `string` | `"MUTABLE"` | no |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | The name of the ECR repository | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_this_ecr_repository_arn"></a> [this\_ecr\_repository\_arn](#output\_this\_ecr\_repository\_arn) | ECR repository ARN |
| <a name="output_this_ecr_repository_id"></a> [this\_ecr\_repository\_id](#output\_this\_ecr\_repository\_id) | ECR repository ID |
| <a name="output_this_ecr_repository_url"></a> [this\_ecr\_repository\_url](#output\_this\_ecr\_repository\_url) | ECR repository URL |
<!-- END_TF_DOCS -->
