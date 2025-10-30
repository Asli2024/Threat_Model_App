variable "name" {
  description = "Name for the WAFv2 Web ACL and metric"
  type        = string
  default     = "ThreatComposerAppWebACL"
}

variable "description" {
  description = "Description for the WAFv2 Web ACL"
  type        = string
  default     = "Web ACL for Threat Composer Application"
}

variable "scope" {
  description = "Scope of the WAFv2 Web ACL (CLOUDFRONT or REGIONAL)"
  type        = string
  default     = "CLOUDFRONT"

  validation {
    condition     = contains(["CLOUDFRONT", "REGIONAL"], var.scope)
    error_message = "scope must be either CLOUDFRONT or REGIONAL."
  }
}
