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
| [aws_cloudwatch_metric_alarm.alb_target_5xx](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.alb_target_response_time](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.alb_unhealthy_hosts](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.dynamodb_system_errors](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.dynamodb_throttles](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ecs_running_tasks_low](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_kms_alias.sns_key_alias](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/kms_alias) | resource |
| [aws_kms_key.sns_key](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/kms_key) | resource |
| [aws_sns_topic.cloudwatch_alarms](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.alarm_email](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/sns_topic_subscription) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.sns_kms_key_policy](https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_email"></a> [alarm\_email](#input\_alarm\_email) | Email address to receive CloudWatch alarm notifications (must confirm subscription) | `list(string)` | `[]` | no |
| <a name="input_alb_5xx_evaluation_periods"></a> [alb\_5xx\_evaluation\_periods](#input\_alb\_5xx\_evaluation\_periods) | ALB target 5XX evaluation periods | `number` | `1` | no |
| <a name="input_alb_5xx_period_seconds"></a> [alb\_5xx\_period\_seconds](#input\_alb\_5xx\_period\_seconds) | ALB target 5XX period in seconds | `number` | `300` | no |
| <a name="input_alb_5xx_threshold"></a> [alb\_5xx\_threshold](#input\_alb\_5xx\_threshold) | ALB target 5XX threshold (Sum over period) | `number` | `0` | no |
| <a name="input_alb_arn_suffix"></a> [alb\_arn\_suffix](#input\_alb\_arn\_suffix) | ALB ARN suffix (app/.../...) required for CloudWatch ALB metrics | `string` | `""` | no |
| <a name="input_alb_latency_evaluation_periods"></a> [alb\_latency\_evaluation\_periods](#input\_alb\_latency\_evaluation\_periods) | Latency alarm evaluation periods | `number` | `2` | no |
| <a name="input_alb_latency_period_seconds"></a> [alb\_latency\_period\_seconds](#input\_alb\_latency\_period\_seconds) | Latency alarm period in seconds | `number` | `300` | no |
| <a name="input_alb_latency_threshold_seconds"></a> [alb\_latency\_threshold\_seconds](#input\_alb\_latency\_threshold\_seconds) | TargetResponseTime threshold in seconds (Average) | `number` | `1` | no |
| <a name="input_alb_unhealthy_evaluation_periods"></a> [alb\_unhealthy\_evaluation\_periods](#input\_alb\_unhealthy\_evaluation\_periods) | Unhealthy host count evaluation periods | `number` | `1` | no |
| <a name="input_alb_unhealthy_period_seconds"></a> [alb\_unhealthy\_period\_seconds](#input\_alb\_unhealthy\_period\_seconds) | Unhealthy host count period in seconds | `number` | `300` | no |
| <a name="input_alb_unhealthy_threshold"></a> [alb\_unhealthy\_threshold](#input\_alb\_unhealthy\_threshold) | Unhealthy host count threshold | `number` | `1` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | ECS cluster name | `string` | `""` | no |
| <a name="input_ddb_system_error_evaluation_periods"></a> [ddb\_system\_error\_evaluation\_periods](#input\_ddb\_system\_error\_evaluation\_periods) | DynamoDB SystemErrors alarm evaluation periods | `number` | `1` | no |
| <a name="input_ddb_system_error_period_seconds"></a> [ddb\_system\_error\_period\_seconds](#input\_ddb\_system\_error\_period\_seconds) | DynamoDB SystemErrors alarm period in seconds | `number` | `300` | no |
| <a name="input_ddb_system_error_threshold"></a> [ddb\_system\_error\_threshold](#input\_ddb\_system\_error\_threshold) | DynamoDB SystemErrors threshold (Sum over period) | `number` | `0` | no |
| <a name="input_ddb_throttle_evaluation_periods"></a> [ddb\_throttle\_evaluation\_periods](#input\_ddb\_throttle\_evaluation\_periods) | DynamoDB throttles alarm evaluation periods | `number` | `1` | no |
| <a name="input_ddb_throttle_period_seconds"></a> [ddb\_throttle\_period\_seconds](#input\_ddb\_throttle\_period\_seconds) | DynamoDB throttles alarm period in seconds | `number` | `300` | no |
| <a name="input_ddb_throttle_threshold"></a> [ddb\_throttle\_threshold](#input\_ddb\_throttle\_threshold) | DynamoDB throttled requests threshold (Sum over period) | `number` | `0` | no |
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | The waiting period before the KMS key is deleted | `number` | `7` | no |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | Desired task count for ECS service (used as threshold for running tasks alarm) | `number` | `1` | no |
| <a name="input_dynamodb_table_name"></a> [dynamodb\_table\_name](#input\_dynamodb\_table\_name) | DynamoDB table name | `string` | `""` | no |
| <a name="input_ecs_tasks_evaluation_periods"></a> [ecs\_tasks\_evaluation\_periods](#input\_ecs\_tasks\_evaluation\_periods) | ECS running tasks alarm evaluation periods | `number` | `1` | no |
| <a name="input_ecs_tasks_period_seconds"></a> [ecs\_tasks\_period\_seconds](#input\_ecs\_tasks\_period\_seconds) | ECS running tasks alarm period in seconds | `number` | `60` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (e.g. dev, pre, prod) | `string` | `""` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | ECS service name | `string` | `""` | no |
| <a name="input_target_group_arn_suffix"></a> [target\_group\_arn\_suffix](#input\_target\_group\_arn\_suffix) | Target group ARN suffix (targetgroup/.../...) required for CloudWatch target group metrics | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | SNS topic ARN used for CloudWatch alarm notifications |
| <a name="output_sns_topic_name"></a> [sns\_topic\_name](#output\_sns\_topic\_name) | SNS topic name used for CloudWatch alarm notifications |
<!-- END_TF_DOCS -->
