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
