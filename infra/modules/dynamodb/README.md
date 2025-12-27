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
| <a name="provider_aws.use1"></a> [aws.use1](#provider\_aws.use1) | 6.15.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.dictionary_words](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/dynamodb_table) | resource |
| [aws_kms_key.dynamodb_mrk](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/kms_key) | resource |
| [aws_kms_key_policy.dynamodb_mrk_policy](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/kms_key_policy) | resource |
| [aws_kms_key_policy.dynamodb_mrk_use1_policy](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/kms_key_policy) | resource |
| [aws_kms_replica_key.dynamodb_mrk_use1](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/kms_replica_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.dynamodb_kms_policy](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | The waiting period before the KMS key is deleted | `number` | `7` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region for the primary DynamoDB table | `string` | `"eu-west-2"` | no |
| <a name="input_replica_regions"></a> [replica\_regions](#input\_replica\_regions) | List of regions to replicate DynamoDB table to | `list(string)` | `[]` | no |
| <a name="input_table_name"></a> [table\_name](#input\_table\_name) | Name of the DynamoDB table | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | Primary DynamoDB MRK ARN (eu-west-2) |
| <a name="output_kms_replica_key_arn_use1"></a> [kms\_replica\_key\_arn\_use1](#output\_kms\_replica\_key\_arn\_use1) | Replica DynamoDB MRK ARN (us-east-1) if enabled |
| <a name="output_table_arn"></a> [table\_arn](#output\_table\_arn) | ARN of the DynamoDB table |
| <a name="output_table_name"></a> [table\_name](#output\_table\_name) | Name of the DynamoDB table |
<!-- END_TF_DOCS -->
