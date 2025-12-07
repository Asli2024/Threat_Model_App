variable "name" {
  description = "Name for the WAFv2 Web ACL and metric"
  type        = string
  default     = "EnglishSomaliDictionaryWebACL"
}

variable "description" {
  description = "Description for the WAFv2 Web ACL"
  type        = string
  default     = "Web ACL for English Somali Dictionary Application"
}
