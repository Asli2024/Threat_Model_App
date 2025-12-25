variable "environment" {
  description = "Environment name (e.g. dev, pre, prod)"
  type        = string
  default     = ""
}

variable "alarm_email" {
  description = "Email address to receive CloudWatch alarm notifications (must confirm subscription)"
  type        = list(string)
  default     = []
}

variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
  default     = ""
}

variable "service_name" {
  description = "ECS service name"
  type        = string
  default     = ""
}

variable "desired_count" {
  description = "Desired task count for ECS service (used as threshold for running tasks alarm)"
  type        = number
  default     = 1
}

variable "alb_arn_suffix" {
  description = "ALB ARN suffix (app/.../...) required for CloudWatch ALB metrics"
  type        = string
  default     = ""
}

variable "target_group_arn_suffix" {
  description = "Target group ARN suffix (targetgroup/.../...) required for CloudWatch target group metrics"
  type        = string
  default     = ""
}


variable "dynamodb_table_name" {
  description = "DynamoDB table name"
  type        = string
  default     = ""
}

variable "alb_5xx_threshold" {
  description = "ALB target 5XX threshold (Sum over period)"
  type        = number
  default     = 0
}

variable "alb_5xx_period_seconds" {
  description = "ALB target 5XX period in seconds"
  type        = number
  default     = 300
}

variable "alb_5xx_evaluation_periods" {
  description = "ALB target 5XX evaluation periods"
  type        = number
  default     = 1
}

variable "alb_unhealthy_threshold" {
  description = "Unhealthy host count threshold"
  type        = number
  default     = 1
}

variable "alb_unhealthy_period_seconds" {
  description = "Unhealthy host count period in seconds"
  type        = number
  default     = 300
}

variable "alb_unhealthy_evaluation_periods" {
  description = "Unhealthy host count evaluation periods"
  type        = number
  default     = 1
}

variable "alb_latency_threshold_seconds" {
  description = "TargetResponseTime threshold in seconds (Average)"
  type        = number
  default     = 1
}

variable "alb_latency_period_seconds" {
  description = "Latency alarm period in seconds"
  type        = number
  default     = 300
}

variable "alb_latency_evaluation_periods" {
  description = "Latency alarm evaluation periods"
  type        = number
  default     = 2
}

variable "ecs_tasks_period_seconds" {
  description = "ECS running tasks alarm period in seconds"
  type        = number
  default     = 60
}

variable "ecs_tasks_evaluation_periods" {
  description = "ECS running tasks alarm evaluation periods"
  type        = number
  default     = 1
}

variable "ddb_throttle_threshold" {
  description = "DynamoDB throttled requests threshold (Sum over period)"
  type        = number
  default     = 0
}

variable "ddb_throttle_period_seconds" {
  description = "DynamoDB throttles alarm period in seconds"
  type        = number
  default     = 300
}

variable "ddb_throttle_evaluation_periods" {
  description = "DynamoDB throttles alarm evaluation periods"
  type        = number
  default     = 1
}

variable "ddb_system_error_threshold" {
  description = "DynamoDB SystemErrors threshold (Sum over period)"
  type        = number
  default     = 0
}

variable "ddb_system_error_period_seconds" {
  description = "DynamoDB SystemErrors alarm period in seconds"
  type        = number
  default     = 300
}

variable "ddb_system_error_evaluation_periods" {
  description = "DynamoDB SystemErrors alarm evaluation periods"
  type        = number
  default     = 1
}

variable "deletion_window_in_days" {
  description = "The waiting period before the KMS key is deleted"
  type        = number
  default     = 7
}
