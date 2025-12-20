variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = ""
}

variable "target_group_name" {
  type    = string
  default = ""
}

variable "target_group_port" {
  description = "target group port"
  type        = number
  default     = 8000
}

variable "target_group_protocol" {
  description = "value of the protocol to use"
  type        = string
  default     = "HTTP"
}

variable "health_check_path" {
  description = "Path for health check"
  type        = string
  default     = "/api/health"
}

variable "security_group_id" {
  description = "Security group ID to associate with the ALB"
  type        = string
  default     = ""
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the ALB"
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN for HTTPS listener"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment identifier used for unique ALB naming"
  type        = string
  default     = ""
}
