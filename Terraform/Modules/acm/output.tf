output "certificate_arn" {
  description = "ARN of the issued/validated ACM certificate"
  value       = aws_acm_certificate.cert.arn
}
