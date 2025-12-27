variable "dashboard_name" {
  description = "Name of the CloudWatch dashboard"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "service_name" {
  description = "ECS service name"
  type        = string
}

variable "alb_arn_suffix" {
  description = "ALB ARN suffix (app/.../...) required for CloudWatch ALB metrics"
  type        = string
}

variable "target_group_arn_suffix" {
  description = "Target group ARN suffix (targetgroup/.../...) required for CloudWatch target group metrics"
  type        = string
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name for dashboard widgets"
  type        = string
}
