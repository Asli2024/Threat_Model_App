output "hosted_zone_id" {
  description = "ID of the created hosted zone"
  value       = aws_route53_zone.this.zone_id
}

output "zone_name" {
  description = "Name of the created hosted zone"
  value       = aws_route53_zone.this.name
}

output "name_servers" {
  description = "Nameservers for the created hosted zone (use for delegation)"
  value       = aws_route53_zone.this.name_servers
}

output "alias_fqdn" {
  description = "FQDN of the created A (ALIAS) record"
  value       = try(aws_route53_record.alias.fqdn, null)
}

output "delegation_record_name" {
  description = "Name of the NS delegation record created in the parent zone"
  value       = aws_route53_record.delegate_subdomain_ns.name
}
