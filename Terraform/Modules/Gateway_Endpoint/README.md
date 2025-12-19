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
| [aws_vpc_endpoint.gateway](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/vpc_endpoint) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix for endpoint names | `string` | `"vpce"` | no |
| <a name="input_route_table_ids"></a> [route\_table\_ids](#input\_route\_table\_ids) | List of route table IDs | `list(string)` | n/a | yes |
| <a name="input_service_names"></a> [service\_names](#input\_service\_names) | List of AWS service names for gateway endpoints | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gateway_endpoint_arns"></a> [gateway\_endpoint\_arns](#output\_gateway\_endpoint\_arns) | Map of gateway endpoint ARNs |
| <a name="output_gateway_endpoint_ids"></a> [gateway\_endpoint\_ids](#output\_gateway\_endpoint\_ids) | Map of gateway endpoint IDs |
<!-- END_TF_DOCS -->
