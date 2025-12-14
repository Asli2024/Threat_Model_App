variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "replica_regions" {
  description = "List of regions to replicate DynamoDB table to"
  type        = list(string)
  default     = []
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "ecs_task_role_name" {
  description = "Name of the ECS task role that needs access to DynamoDB"
  type        = string
}

variable "region" {
  description = "AWS region where the primary DynamoDB table is created"
  type        = string
}
