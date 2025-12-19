variable "service_names" { # Changed from service_name (singular) to service_names (plural)
  description = "List of AWS service names for gateway endpoints"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "route_table_ids" {
  description = "List of route table IDs"
  type        = list(string)
}

variable "name_prefix" {
  description = "Prefix for endpoint names"
  type        = string
  default     = "vpce"
}
