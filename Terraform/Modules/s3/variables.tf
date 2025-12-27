variable "aws_region" {
  description = "The AWS region where the resources will be created."
  type        = string
  default     = ""
}

variable "uploader_role_name" {
  description = "IAM role name allowed to access the bucket and KMS key."
  type        = string
  default     = ""
}

variable "lifecycle_prefix" {
  description = "Prefix filter for the lifecycle rule."
  type        = string
  default     = ""
}

variable "transition_to_ia_days" {
  description = "Days after which noncurrent objects transition to STANDARD_IA."
  type        = number
  default     = 30
}

variable "transition_to_glacier_days" {
  description = "Days after which noncurrent objects transition to GLACIER."
  type        = number
  default     = 60
}

variable "transition_to_deep_glacier_days" {
  description = "Days after which noncurrent objects transition to DEEP_ARCHIVE."
  type        = number
  default     = 150
}

variable "prefix" {
  description = "Project or team prefix"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment name like dev, stage, prod"
  type        = string
  default     = ""
}

variable "resource" {
  description = "Type of resource, e.g., s3, vpc, alb"
  type        = string
  default     = "s3"
}

variable "random_length" {
  description = "Length of random suffix"
  type        = number
  default     = 6
}

variable "deletion_window_in_days" {
  description = "The waiting period before the KMS key is deleted"
  type        = number
  default     = 7
}

variable "s3_kms_key_alias_name" {
  description = "The alias name for the KMS key used for S3 bucket encryption (must start with alias/)"
  type        = string
  default     = "alias/s3-bucket-kms-keys"
}
