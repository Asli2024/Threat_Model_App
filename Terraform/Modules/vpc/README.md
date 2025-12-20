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
| [aws_cloudwatch_log_group.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_flow_log.main](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/flow_log) | resource |
| [aws_iam_role.flow_log_role](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.vpc_flow_logs_to_cw](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/iam_role_policy) | resource |
| [aws_internet_gateway.IGW](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/internet_gateway) | resource |
| [aws_kms_alias.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/kms_alias) | resource |
| [aws_kms_key.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/kms_key) | resource |
| [aws_route.public_internet_gateway_route](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/route) | resource |
| [aws_route_table.private_rt](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/route_table) | resource |
| [aws_route_table.public_rt](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/route_table) | resource |
| [aws_route_table_association.private_rt_association](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_rt_association](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/route_table_association) | resource |
| [aws_subnet.private_subnet](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/subnet) | resource |
| [aws_subnet.public_subnet](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/subnet) | resource |
| [aws_vpc.main_vpc](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/vpc) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.vpc_flow_logs_assume_default](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.vpc_flow_logs_kms_default](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.vpc_flow_logs_role_default](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Enable DNS hostnames in the VPC | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Enable DNS support in the VPC | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment identifier used for log group and KMS alias uniqueness | `string` | `""` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix used for Name tags on all VPC resources | `string` | `""` | no |
| <a name="input_private_subnet_cidr_blocks"></a> [private\_subnet\_cidr\_blocks](#input\_private\_subnet\_cidr\_blocks) | The CIDR block for the private subnet. | `list(string)` | `[]` | no |
| <a name="input_public_subnet_cidr_blocks"></a> [public\_subnet\_cidr\_blocks](#input\_public\_subnet\_cidr\_blocks) | The CIDR block for the public subnet. | `list(string)` | `[]` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | The CIDR block for the VPC | `string` | `""` | no |
| <a name="input_vpc_flow_log_kms_key_policy_json"></a> [vpc\_flow\_log\_kms\_key\_policy\_json](#input\_vpc\_flow\_log\_kms\_key\_policy\_json) | KMS Key Policy JSON for VPC Flow Logs KMS Key | `string` | `""` | no |
| <a name="input_vpc_flow_log_role_name"></a> [vpc\_flow\_log\_role\_name](#input\_vpc\_flow\_log\_role\_name) | IAM Role name for VPC Flow Logs | `string` | `""` | no |
| <a name="input_vpc_flow_log_role_policy_json"></a> [vpc\_flow\_log\_role\_policy\_json](#input\_vpc\_flow\_log\_role\_policy\_json) | The IAM policy document for the VPC Flow Log role | `string` | `""` | no |
| <a name="input_vpc_flow_logs_assume_role"></a> [vpc\_flow\_logs\_assume\_role](#input\_vpc\_flow\_logs\_assume\_role) | IAM Assume Role Policy JSON for VPC Flow Logs Role | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_route_table_id"></a> [private\_route\_table\_id](#output\_private\_route\_table\_id) | ID of the private route table |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | IDs of the private subnets |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | IDs of the public subnets |
| <a name="output_vpc_flow_log_id"></a> [vpc\_flow\_log\_id](#output\_vpc\_flow\_log\_id) | The ID of the VPC Flow Log |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
<!-- END_TF_DOCS -->
