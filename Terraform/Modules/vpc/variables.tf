variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = ""
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "private_subnet_cidr_blocks" {
  description = "The CIDR block for the private subnet."
  type        = list(string)
  default     = []
}

variable "public_subnet_cidr_blocks" {
  description = "The CIDR block for the public subnet."
  type        = list(string)
  default     = []
}

variable "vpc_flow_log_role_name" {
  description = "IAM Role name for VPC Flow Logs"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment identifier used for log group and KMS alias uniqueness"
  type        = string
  default     = ""
}

variable "vpc_flow_log_kms_key_policy_json" {
  description = "KMS Key Policy JSON for VPC Flow Logs KMS Key"
  type        = string
  default     = ""
}

variable "vpc_flow_logs_assume_role" {
  description = "IAM Assume Role Policy JSON for VPC Flow Logs Role"
  type        = string
  default     = ""
}

variable "vpc_flow_log_role_policy_json" {
  description = "The IAM policy document for the VPC Flow Log role"
  type        = string
  default     = ""
}

variable "name_prefix" {
  description = "Prefix used for Name tags on all VPC resources"
  type        = string
  default     = ""
}
