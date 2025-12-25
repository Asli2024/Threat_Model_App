variable "repository_name" {
  description = "The name of the ECR repository"
  type        = string
  default     = ""
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository"
  type        = string
  default     = "MUTABLE"
}
variable "deletion_window_in_days" {
  description = "The waiting period before the KMS key is deleted"
  type        = number
  default     = 7
}
