variable "domain_name" {
  description = "FQDN for the certificate"
  type        = string
  default     = ""
}

variable "zone_id" {
  description = "Public Route 53 hosted zone ID where DNS validation records will be created"
  type        = string
  default     = ""
}

variable "subject_alternative_names" {
  description = "Optional SANs, e.g., [\"www.dev.techwithaden.com\"]"
  type        = list(string)
  default     = []
}

variable "dns_ttl" {
  description = "TTL for ACM DNS validation records"
  type        = number
  default     = 60
}

variable "validation_timeout" {
  description = "Timeout for aws_acm_certificate_validation.create"
  type        = string
  default     = "2h"
}
