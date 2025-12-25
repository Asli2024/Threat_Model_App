variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-2"
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
    Owner       = "Asli Aden"
    Project     = "English Somali Dictionary App"
  }
}


variable "prefix" {
  description = "Project or team prefix"
  type        = string
  default     = "english-somali-dictionary-app"
}

variable "environment" {
  description = "Environment name like dev, stage, prod"
  type        = string
  default     = "dev"
}
