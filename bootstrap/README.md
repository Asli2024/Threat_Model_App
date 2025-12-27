<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | = 6.15.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.15.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecr"></a> [ecr](#module\_ecr) | ../terraform/modules/ecr | n/a |
| <a name="module_iam_oidc_role"></a> [iam\_oidc\_role](#module\_iam\_oidc\_role) | ../terraform/modules/iam | n/a |
| <a name="module_s3"></a> [s3](#module\_s3) | ../terraform/modules/s3 | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.oidc_assume_role](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.oidc_policy](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common tags to apply to all resources | `map(string)` | <pre>{<br/>  "Environment": "dev",<br/>  "ManagedBy": "Terraform",<br/>  "Owner": "Asli Aden",<br/>  "Project": "English Somali Dictionary App"<br/>}</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name like dev, stage, prod | `string` | `"dev"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Project or team prefix | `string` | `"english-somali-dictionary-app"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region to deploy resources | `string` | `"eu-west-2"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
