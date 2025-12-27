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
| [aws_vpc_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint_policy.this](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/vpc_endpoint_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.default_vpce_policy](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attach_policy"></a> [attach\_policy](#input\_attach\_policy) | Whether to attach an endpoint policy. | `bool` | `true` | no |
| <a name="input_endpoint_policy_json"></a> [endpoint\_policy\_json](#input\_endpoint\_policy\_json) | Optional IAM policy JSON to attach. If null, a safe default policy is generated. | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (e.g., dev, staging, prod) to include in resource names. | `string` | `""` | no |
| <a name="input_ip_address_type"></a> [ip\_address\_type](#input\_ip\_address\_type) | The IP address type for the endpoint (ipv4 or dualstack). | `string` | `"ipv4"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix to use for naming interface VPC endpoints (Name tag). | `string` | `"vpce"` | no |
| <a name="input_private_dns_enabled"></a> [private\_dns\_enabled](#input\_private\_dns\_enabled) | Whether to enable private DNS for the endpoint. | `bool` | `true` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security group IDs to associate with the endpoint ENIs. | `list(string)` | `[]` | no |
| <a name="input_service_names"></a> [service\_names](#input\_service\_names) | List of interface endpoint service names to create endpoints for. | `list(string)` | `[]` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Private subnet IDs for the endpoint ENIs. | `list(string)` | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID where the interface endpoints will be created. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_entries"></a> [dns\_entries](#output\_dns\_entries) | Map of service\_name => DNS entries. |
| <a name="output_ids"></a> [ids](#output\_ids) | Map of service\_name => VPC endpoint ID. |
| <a name="output_network_interface_ids"></a> [network\_interface\_ids](#output\_network\_interface\_ids) | Map of service\_name => list of ENI IDs. |
<!-- END_TF_DOCS -->
