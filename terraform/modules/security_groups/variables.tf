variable "vpc_id" {
  description = "ID of the VPC to associate the security group with"
  type        = string
  default     = ""
}

variable "sg_name" {
  description = "Name of the security group"
  type        = string
  default     = ""
}

variable "ingress_rules" {
  description = "Ingress rules"
  type = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    description      = string
    cidr_blocks      = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    security_groups  = optional(list(string))
    prefix_list_ids  = optional(list(string))
  }))
  default = []
}

variable "egress_rules" {
  description = "Egress rules"
  type = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    description      = string
    cidr_blocks      = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    security_groups  = optional(list(string))
    prefix_list_ids  = optional(list(string))
  }))
  default = []
}

variable "sg_description" {
  description = "Description of the security group"
  type        = string
  default     = "Secuirity group description"
}
