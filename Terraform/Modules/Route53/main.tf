resource "aws_route53_zone" "this" {
  name = var.domain_name
}

resource "aws_route53_record" "alias" {
  zone_id = aws_route53_zone.this.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.dns_name
    zone_id                = var.zone_id
    evaluate_target_health = var.evaluate_target_health
  }
}

data "aws_route53_zone" "parent" {
  name         = var.parent_domain_name
  private_zone = false
}

resource "aws_route53_record" "delegate_subdomain_ns" {
  zone_id = data.aws_route53_zone.parent.zone_id
  name    = aws_route53_zone.this.name
  type    = "NS"
  ttl     = 300
  records = aws_route53_zone.this.name_servers
}
