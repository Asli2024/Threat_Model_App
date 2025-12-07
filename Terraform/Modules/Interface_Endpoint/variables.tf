variable "service_names" {
  description = "List of interface endpoint service names to create endpoints for."
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "VPC ID where the interface endpoints will be created."
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "Private subnet IDs for the endpoint ENIs."
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "Security group IDs to associate with the endpoint ENIs."
  type        = list(string)
  default     = []
}

variable "private_dns_enabled" {
  description = "Whether to enable private DNS for the endpoint."
  type        = bool
  default     = true
}

variable "ip_address_type" {
  description = "The IP address type for the endpoint (ipv4 or dualstack)."
  type        = string
  default     = "ipv4"
}

variable "attach_policy" {
  description = "Whether to attach an endpoint policy."
  type        = bool
  default     = true
}

variable "endpoint_policy_json" {
  description = "Optional IAM policy JSON to attach. If null, a safe default policy is generated."
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Prefix to use for naming interface VPC endpoints (Name tag)."
  type        = string
  default     = "vpce"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod) to include in resource names."
  type        = string
  default     = ""
}
