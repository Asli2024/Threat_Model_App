variable "role_name" {
  description = "The name of the IAM role"
  type        = string
  default     = ""
}

variable "assume_role_policy" {
  description = "The policy that grants an entity permission to assume the role"
  type        = string
  default     = ""
}

variable "managed_policy_arns" {
  description = "A list of ARNs of IAM managed policies to attach"
  type        = list(string)
  default     = []
}

variable "create_custom_policy" {
  description = "Whether to create a custom IAM policy"
  type        = bool
  default     = false
}

variable "custom_policy_name" {
  description = "Name for the custom IAM policy"
  type        = string
  default     = ""
}

variable "custom_policy_document" {
  description = "IAM policy document for the custom policy (JSON string or data source output)"
  type        = string
  default     = ""
}
