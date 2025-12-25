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
| [aws_appautoscaling_policy.cpu](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.this](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/appautoscaling_target) | resource |
| [aws_cloudwatch_log_group.ecs_log_group](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.this](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.this](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/ecs_task_definition) | resource |
| [aws_kms_alias.ecs_log_key_alias](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/kms_alias) | resource |
| [aws_kms_key.ecs_log_key](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/kms_key) | resource |
| [aws_kms_key_policy.ecs_log_key_policy](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/kms_key_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.ecs_log_kms_key_policy](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_kms_key_alias_ecs_log"></a> [aws\_kms\_key\_alias\_ecs\_log](#input\_aws\_kms\_key\_alias\_ecs\_log) | KMS alias for the module-managed key (must start with alias/). Leave empty to skip alias. | `string` | `""` | no |
| <a name="input_bedrock_model_id"></a> [bedrock\_model\_id](#input\_bedrock\_model\_id) | Bedrock model ID for translations | `string` | `"anthropic.claude-3-7-sonnet-20250219-v1:0"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the ECS cluster | `string` | `""` | no |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | Name of the container | `string` | `""` | no |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | Container port to expose | `number` | `null` | no |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | CPU units for the task | `string` | `""` | no |
| <a name="input_cpu_target"></a> [cpu\_target](#input\_cpu\_target) | Target average CPU utilization (%) before scaling | `number` | `null` | no |
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | The waiting period before the KMS key is deleted | `number` | `7` | no |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | How many tasks to run | `number` | `null` | no |
| <a name="input_dynamodb_table_name"></a> [dynamodb\_table\_name](#input\_dynamodb\_table\_name) | Name of the DynamoDB table for dictionary data | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment identifier used to suffix KMS alias if provided | `string` | `""` | no |
| <a name="input_execution_role_arn"></a> [execution\_role\_arn](#input\_execution\_role\_arn) | IAM role ARN for ECS task execution | `string` | `""` | no |
| <a name="input_family"></a> [family](#input\_family) | Task definition family name | `string` | `""` | no |
| <a name="input_force_new_deployment"></a> [force\_new\_deployment](#input\_force\_new\_deployment) | Force a new deployment of the ECS service | `bool` | `false` | no |
| <a name="input_image"></a> [image](#input\_image) | Docker image URI | `string` | `""` | no |
| <a name="input_max_capacity"></a> [max\_capacity](#input\_max\_capacity) | Maximum number of ECS tasks | `number` | `null` | no |
| <a name="input_max_tokens"></a> [max\_tokens](#input\_max\_tokens) | Maximum number of tokens for Bedrock model output | `number` | `1000` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | Memory for the task in MiB | `string` | `""` | no |
| <a name="input_min_capacity"></a> [min\_capacity](#input\_min\_capacity) | Minimum number of ECS tasks | `number` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region for CloudWatch Logs | `string` | `""` | no |
| <a name="input_security_group_id"></a> [security\_group\_id](#input\_security\_group\_id) | Security group ID for the ECS service | `string` | `""` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | ECS service name | `string` | `""` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of private subnet IDs | `list(string)` | `[]` | no |
| <a name="input_target_group_arn"></a> [target\_group\_arn](#input\_target\_group\_arn) | Target group ARN from the ALB | `string` | `""` | no |
| <a name="input_task_role_arn"></a> [task\_role\_arn](#input\_task\_role\_arn) | ARN of IAM role for ECS task runtime permissions (used by application code) | `string` | `""` | no |
| <a name="input_temperature"></a> [temperature](#input\_temperature) | Temperature for Bedrock model | `number` | `0.3` | no |
| <a name="input_top_p"></a> [top\_p](#input\_top\_p) | Top P for Bedrock model | `number` | `0.9` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_autoscaling_policy_name"></a> [autoscaling\_policy\_name](#output\_autoscaling\_policy\_name) | n/a |
| <a name="output_cloudwatch_log_group_arn"></a> [cloudwatch\_log\_group\_arn](#output\_cloudwatch\_log\_group\_arn) | CloudWatch Log Group ARN for ECS logs |
| <a name="output_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#output\_cloudwatch\_log\_group\_name) | CloudWatch Log Group name for ECS logs |
| <a name="output_container_name"></a> [container\_name](#output\_container\_name) | The name of the container used in the task definition |
| <a name="output_ecs_cluster_id"></a> [ecs\_cluster\_id](#output\_ecs\_cluster\_id) | The ID of the ECS cluster |
| <a name="output_ecs_service_name"></a> [ecs\_service\_name](#output\_ecs\_service\_name) | The name of the ECS service |
| <a name="output_kms_key_alias_name"></a> [kms\_key\_alias\_name](#output\_kms\_key\_alias\_name) | KMS Key Alias for ECS log encryption |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | KMS Key ARN for ECS log encryption |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | KMS Key ID for ECS log encryption |
| <a name="output_task_definition_arn"></a> [task\_definition\_arn](#output\_task\_definition\_arn) | The full ARN of the ECS task definition |
<!-- END_TF_DOCS -->
