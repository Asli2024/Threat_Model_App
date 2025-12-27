variable "region" {
  description = "The region in which the VPC will be created."
  type        = string
  default     = ""
}

variable "common_tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = ""
    ManagedBy   = ""
    Owner       = ""
    Project     = ""
  }
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

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = ""
}

variable "vpc_flow_log_role_name" {
  description = "IAM Role name for VPC Flow Logs"
  type        = string
  default     = ""
}

variable "gateway_endpoints" {
  description = "List of gateway endpoint service names"
  type        = list(string)
  default     = []
}

variable "interface_endpoints" {
  description = "List of interface endpoint service names"
  type        = list(string)
  default     = []
}

variable "ip_address_type" {
  description = "IP address type for interface endpoints"
  type        = string
  default     = "ipv4"
}
variable "domain_name" {
  description = "Domain name"
  type        = string
  default     = ""
}
variable "parent_domain_name" {
  description = "Existing parent zone to delegate from (e.g., techwithaden.com). Must exist in Route 53."
  type        = string
  default     = ""
}
variable "aliases" {
  description = "List of domain names (CNAMEs) for the CloudFront distribution"
  type        = list(string)
  default     = []
}

variable "target_group_name" {
  description = "Name of the target group"
  type        = string
  default     = ""
}

variable "target_group_port" {
  description = "Port for the target group"
  type        = number
  default     = null
}

variable "target_group_protocol" {
  description = "Protocol for the target group"
  type        = string
  default     = "HTTP"
}

variable "health_check_path" {
  description = "Health check path for the target group"
  type        = string
  default     = "/api/health"
}

variable "dns_ttl" {
  description = "TTL for DNS records"
  type        = number
  default     = 60
}

variable "validation_timeout" {
  description = "Timeout for ACM certificate validation"
  type        = string
  default     = "2h"
}

variable "cluster_name" {
  description = "ECS Cluster Name"
  type        = string
  default     = ""
}

variable "desired_count" {
  description = "Number of desired ECS tasks"
  type        = number
  default     = null
}

variable "container_port" {
  description = "Port on which the container listens"
  type        = number
  default     = null
}

variable "cpu" {
  description = "CPU units for the ECS task"
  type        = string
  default     = "256"
}

variable "memory" {
  description = "Memory in MB for the ECS task"
  type        = string
  default     = "512"
}

variable "cpu_target" {
  description = "CPU utilization target percentage for ECS service auto-scaling"
  type        = number
  default     = 50
}

variable "min_capacity" {
  description = "Minimum capacity for ECS service auto-scaling"
  type        = number
  default     = null
}

variable "max_capacity" {
  description = "Maximum capacity for ECS service auto-scaling"
  type        = number
  default     = null
}

variable "family" {
  description = "Family name for the ECS task definition"
  type        = string
  default     = "english-somali-dictionary-task-family"
}
variable "service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Short environment identifier used for naming (e.g. dev, staging, prod)."
  type        = string
  default     = ""
}

variable "replica_regions" {
  description = "List of regions to replicate DynamoDB table to"
  type        = list(string)
  default     = []
}

variable "bedrock_model_id" {
  description = "Bedrock model ID for translations"
  type        = string
  default     = "anthropic.claude-3-7-sonnet-20250219-v1:0"
}
variable "max_tokens" {
  description = "Maximum tokens for Bedrock responses"
  type        = number
  default     = 1000
}

variable "alarm_email" {
  description = "Email address to receive CloudWatch alarm notifications (must confirm subscription)"
  type        = list(string)
  default     = []
}
