variable "domain_name" {
  description = "FQDN of the hosted zone to create (e.g., dev.techwithaden.com or techwithaden.com)"
  type        = string
  default     = ""
}

variable "parent_domain_name" {
  description = "Existing parent zone to delegate from (e.g., techwithaden.com). Must exist in Route 53."
  type        = string
  default     = ""
}

variable "dns_name" {
  description = "ALB DNS name (e.g., myalb-123.eu-west-2.elb.amazonaws.com)"
  type        = string
  default     = ""
}

variable "zone_id" {
  description = "ALB hosted zone ID (from aws_lb.zone_id)"
  type        = string
  default     = ""
}

variable "evaluate_target_health" {
  description = "Whether Route 53 should evaluate target health for the ALIAS"
  type        = bool
  default     = false
}
