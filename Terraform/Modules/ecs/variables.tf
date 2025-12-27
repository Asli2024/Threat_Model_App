variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = ""
}

variable "family" {
  description = "Task definition family name"
  type        = string
  default     = ""
}

variable "container_name" {
  description = "Name of the container"
  type        = string
  default     = ""
}

variable "image" {
  description = "Docker image URI"
  type        = string
  default     = ""
}

variable "container_port" {
  description = "Container port to expose"
  type        = number
  default     = null
}

variable "cpu" {
  description = "CPU units for the task"
  type        = string
  default     = ""
}

variable "memory" {
  description = "Memory for the task in MiB"
  type        = string
  default     = ""
}

variable "region" {
  description = "AWS region for CloudWatch Logs"
  type        = string
  default     = ""
}

variable "execution_role_arn" {
  description = "IAM role ARN for ECS task execution"
  type        = string
  default     = ""
}

variable "service_name" {
  description = "ECS service name"
  type        = string
  default     = ""
}

variable "desired_count" {
  description = "How many tasks to run"
  type        = number
  default     = null
}

variable "subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
  default     = []
}

variable "security_group_id" {
  description = "Security group ID for the ECS service"
  type        = string
  default     = ""
}

variable "target_group_arn" {
  description = "Target group ARN from the ALB"
  type        = string
  default     = ""
}

variable "min_capacity" {
  description = "Minimum number of ECS tasks"
  type        = number
  default     = null
}

variable "max_capacity" {
  description = "Maximum number of ECS tasks"
  type        = number
  default     = null
}

variable "cpu_target" {
  description = "Target average CPU utilization (%) before scaling"
  type        = number
  default     = null
}

variable "force_new_deployment" {
  description = "Force a new deployment of the ECS service"
  type        = bool
  default     = false
}

variable "aws_kms_key_alias_ecs_log" {
  type        = string
  description = "KMS alias for the module-managed key (must start with alias/). Leave empty to skip alias."
  default     = ""
}

variable "environment" {
  description = "Environment identifier used to suffix KMS alias if provided"
  type        = string
  default     = ""
}

variable "task_role_arn" {
  description = "ARN of IAM role for ECS task runtime permissions (used by application code)"
  type        = string
  default     = ""
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table for dictionary data"
  type        = string
}

variable "bedrock_model_id" {
  description = "Bedrock model ID for translations"
  type        = string
  default     = "anthropic.claude-3-7-sonnet-20250219-v1:0"
}

variable "temperature" {
  description = "Temperature for Bedrock model"
  type        = number
  default     = 0.3
}

variable "top_p" {
  description = "Top P for Bedrock model"
  type        = number
  default     = 0.9
}

variable "max_tokens" {
  description = "Maximum number of tokens for Bedrock model output"
  type        = number
  default     = 1000
}

variable "deletion_window_in_days" {
  description = "The waiting period before the KMS key is deleted"
  type        = number
  default     = 7
}
