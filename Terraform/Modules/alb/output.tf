output "dns_name" {
  value = aws_lb.this.dns_name
}
output "alb_zone_id" {
  value = aws_lb.this.zone_id
}

output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.this.arn
}

output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "alb_arn_suffix" {
  description = "ARN suffix required for CloudWatch ALB metrics"
  value       = aws_lb.this.arn_suffix
}

output "target_group_arn_suffix" {
  description = "ARN suffix required for CloudWatch target group metrics"
  value       = aws_lb_target_group.this.arn_suffix
}
