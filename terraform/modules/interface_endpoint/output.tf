output "ids" {
  description = "Map of service_name => VPC endpoint ID."
  value       = { for k, ep in aws_vpc_endpoint.this : k => ep.id }
}

output "dns_entries" {
  description = "Map of service_name => DNS entries."
  value       = { for k, ep in aws_vpc_endpoint.this : k => ep.dns_entry }
}

output "network_interface_ids" {
  description = "Map of service_name => list of ENI IDs."
  value       = { for k, ep in aws_vpc_endpoint.this : k => ep.network_interface_ids }
}
