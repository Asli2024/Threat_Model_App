output "table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.dictionary_words.name
}

output "table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.dictionary_words.arn
}

output "kms_key_arn" {
  description = "Primary DynamoDB MRK ARN (eu-west-2)"
  value       = aws_kms_key.dynamodb_mrk.arn
}

output "kms_replica_key_arn_use1" {
  description = "Replica DynamoDB MRK ARN (us-east-1) if enabled"
  value       = local.enable_use1 ? aws_kms_replica_key.dynamodb_mrk_use1[0].arn : null
}
