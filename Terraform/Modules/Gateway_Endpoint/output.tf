output "gateway_endpoint_ids" {
  description = "Map of gateway endpoint IDs"
  value       = { for k, v in aws_vpc_endpoint.gateway : k => v.id }
}

output "gateway_endpoint_arns" {
  description = "Map of gateway endpoint ARNs"
  value       = { for k, v in aws_vpc_endpoint.gateway : k => v.arn }
}
