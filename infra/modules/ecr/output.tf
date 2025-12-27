output "this_ecr_repository_id" {
  description = "ECR repository ID"
  value       = aws_ecr_repository.this.id
}

output "this_ecr_repository_arn" {
  description = "ECR repository ARN"
  value       = aws_ecr_repository.this.arn
}

output "this_ecr_repository_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.this.repository_url
}
