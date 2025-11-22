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
