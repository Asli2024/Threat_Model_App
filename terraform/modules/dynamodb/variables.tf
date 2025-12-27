variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "replica_regions" {
  description = "List of regions to replicate DynamoDB table to"
  type        = list(string)
  default     = []
}

variable "region" {
  description = "AWS region for the primary DynamoDB table"
  type        = string
  default     = "eu-west-2"
}

variable "deletion_window_in_days" {
  description = "The waiting period before the KMS key is deleted"
  type        = number
  default     = 7
}
