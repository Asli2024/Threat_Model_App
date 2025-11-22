variable "vpc_id" {
  description = "The ID of the VPC where the gateway endpoint will be created."
  type        = string
}

variable "service_name" {
  description = "The name of the service for the gateway endpoint (e.g., com.amazonaws.us-east-1.s3)."
  type        = list(string)
}

variable "route_table_ids" {
  description = "A list of route table IDs to associate with the gateway endpoint."
  type        = list(string)
}

variable "name_prefix" {
  description = "Prefix used for the Name tag applied to the gateway endpoint."
  type        = string
  default     = "gw"
}
