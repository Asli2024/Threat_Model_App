output "bucket_name" {
  description = "The name of the main S3 bucket."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN of the main S3 bucket."
  value       = aws_s3_bucket.this.arn
}

output "kms_key_id" {
  description = "ID of the KMS key used for S3 bucket encryption."
  value       = aws_kms_key.this.key_id
}

output "kms_key_arn" {
  description = "ARN of the KMS key used for S3 bucket encryption."
  value       = aws_kms_key.this.arn
}
