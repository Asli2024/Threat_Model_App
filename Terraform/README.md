## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | = 6.15.0 |
| <a name="requirement_docker"></a> [docker](#requirement\_docker) | ~> 3.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.9.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.15.0 |
| <a name="provider_aws.use1"></a> [aws.use1](#provider\_aws.use1) | 6.15.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm_alb"></a> [acm\_alb](#module\_acm\_alb) | ../Terraform/Modules/ACM | n/a |
| <a name="module_alb"></a> [alb](#module\_alb) | ../Terraform/Modules/ALB | n/a |
| <a name="module_alb_sg"></a> [alb\_sg](#module\_alb\_sg) | ../Terraform/Modules/Security_Groups | n/a |
| <a name="module_application_sg"></a> [application\_sg](#module\_application\_sg) | ../Terraform/Modules/Security_Groups | n/a |
| <a name="module_cloudfront"></a> [cloudfront](#module\_cloudfront) | ../Terraform/Modules/Cloudfront | n/a |
| <a name="module_ecs"></a> [ecs](#module\_ecs) | ../Terraform/Modules/ECS | n/a |
| <a name="module_ecs_execution_role"></a> [ecs\_execution\_role](#module\_ecs\_execution\_role) | ../Terraform/Modules/IAM | n/a |
| <a name="module_ecs_task_role"></a> [ecs\_task\_role](#module\_ecs\_task\_role) | ../Terraform/Modules/IAM | n/a |
| <a name="module_gateway_endpoints"></a> [gateway\_endpoints](#module\_gateway\_endpoints) | ../Terraform/Modules/Gateway_Endpoint | n/a |
| <a name="module_interface_endpoints"></a> [interface\_endpoints](#module\_interface\_endpoints) | ../Terraform/Modules/Interface_Endpoint | n/a |
| <a name="module_route53_new_zone"></a> [route53\_new\_zone](#module\_route53\_new\_zone) | ../Terraform/Modules/Route53 | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ../Terraform/Modules/VPC | n/a |
| <a name="module_vpce_sg"></a> [vpce\_sg](#module\_vpce\_sg) | ../Terraform/Modules/Security_Groups | n/a |
| <a name="module_waf_acl"></a> [waf\_acl](#module\_waf\_acl) | ../Terraform/Modules/WAF | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.cloudfront_cert](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/acm_certificate) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/caller_identity) | data source |
| [aws_ec2_managed_prefix_list.cf_origin](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/ec2_managed_prefix_list) | data source |
| [aws_iam_policy_document.ecs_execution_assume_role](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_execution_policy](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.translate_policy](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aliases"></a> [aliases](#input\_aliases) | List of domain names (CNAMEs) for the CloudFront distribution | `list(string)` | `[]` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | ECS Cluster Name | `string` | `""` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | A map of tags to apply to all resources | `map(string)` | <pre>{<br/>  "Environment": "",<br/>  "ManagedBy": "",<br/>  "Owner": "",<br/>  "Project": ""<br/>}</pre> | no |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | Name of the container in the ECS task | `string` | `""` | no |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | Port on which the container listens | `number` | `null` | no |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | CPU units for the ECS task | `string` | `"256"` | no |
| <a name="input_cpu_target"></a> [cpu\_target](#input\_cpu\_target) | CPU utilization target percentage for ECS service auto-scaling | `number` | `50` | no |
| <a name="input_default_ttl"></a> [default\_ttl](#input\_default\_ttl) | Default TTL for CloudFront cache (in seconds) | `number` | `3600` | no |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | Number of desired ECS tasks | `number` | `null` | no |
| <a name="input_dns_ttl"></a> [dns\_ttl](#input\_dns\_ttl) | TTL for DNS records | `number` | `60` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name | `string` | `""` | no |
| <a name="input_ecs_execution_policy"></a> [ecs\_execution\_policy](#input\_ecs\_execution\_policy) | Name of the ECS execution policy | `string` | `""` | no |
| <a name="input_ecs_execution_role"></a> [ecs\_execution\_role](#input\_ecs\_execution\_role) | Name of the ECS execution role | `string` | `""` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Enable DNS hostnames in the VPC | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Enable DNS support in the VPC | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Short environment identifier used for naming (e.g. dev, staging, prod). | `string` | `""` | no |
| <a name="input_family"></a> [family](#input\_family) | Family name for the ECS task definition | `string` | `"english-somali-dictionary-task-family"` | no |
| <a name="input_gateway_endpoints"></a> [gateway\_endpoints](#input\_gateway\_endpoints) | List of gateway endpoint service names | `list(string)` | `[]` | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | Health check path for the target group | `string` | `"/"` | no |
| <a name="input_interface_endpoints"></a> [interface\_endpoints](#input\_interface\_endpoints) | List of interface endpoint service names | `list(string)` | `[]` | no |
| <a name="input_ip_address_type"></a> [ip\_address\_type](#input\_ip\_address\_type) | IP address type for interface endpoints | `string` | `"ipv4"` | no |
| <a name="input_max_capacity"></a> [max\_capacity](#input\_max\_capacity) | Maximum capacity for ECS service auto-scaling | `number` | `null` | no |
| <a name="input_max_ttl"></a> [max\_ttl](#input\_max\_ttl) | Maximum TTL for CloudFront cache (in seconds) | `number` | `86400` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | Memory in MB for the ECS task | `string` | `"512"` | no |
| <a name="input_min_capacity"></a> [min\_capacity](#input\_min\_capacity) | Minimum capacity for ECS service auto-scaling | `number` | `null` | no |
| <a name="input_min_ttl"></a> [min\_ttl](#input\_min\_ttl) | Minimum TTL for CloudFront cache (in seconds) | `number` | `0` | no |
| <a name="input_parent_domain_name"></a> [parent\_domain\_name](#input\_parent\_domain\_name) | Existing parent zone to delegate from (e.g., techwithaden.com). Must exist in Route 53. | `string` | `""` | no |
| <a name="input_private_subnet_cidr_blocks"></a> [private\_subnet\_cidr\_blocks](#input\_private\_subnet\_cidr\_blocks) | The CIDR block for the private subnet. | `list(string)` | `[]` | no |
| <a name="input_public_subnet_cidr_blocks"></a> [public\_subnet\_cidr\_blocks](#input\_public\_subnet\_cidr\_blocks) | The CIDR block for the public subnet. | `list(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | The region in which the VPC will be created. | `string` | `""` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Name of the ECS service | `string` | `""` | no |
| <a name="input_target_group_name"></a> [target\_group\_name](#input\_target\_group\_name) | Name of the target group | `string` | `""` | no |
| <a name="input_target_group_port"></a> [target\_group\_port](#input\_target\_group\_port) | Port for the target group | `number` | `null` | no |
| <a name="input_target_group_protocol"></a> [target\_group\_protocol](#input\_target\_group\_protocol) | Protocol for the target group | `string` | `"HTTP"` | no |
| <a name="input_validation_timeout"></a> [validation\_timeout](#input\_validation\_timeout) | Timeout for ACM certificate validation | `string` | `"2h"` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | The CIDR block for the VPC | `string` | `""` | no |
| <a name="input_vpc_flow_log_role_name"></a> [vpc\_flow\_log\_role\_name](#input\_vpc\_flow\_log\_role\_name) | IAM Role name for VPC Flow Logs | `string` | `""` | no |
| <a name="input_waf_name"></a> [waf\_name](#input\_waf\_name) | Name for the WAFv3 Web ACL | `string` | `""` | no |

## Outputs

No outputs.
