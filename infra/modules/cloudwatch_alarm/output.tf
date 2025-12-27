output "sns_topic_arn" {
  description = "SNS topic ARN used for CloudWatch alarm notifications"
  value       = aws_sns_topic.cloudwatch_alarms.arn
}

output "sns_topic_name" {
  description = "SNS topic name used for CloudWatch alarm notifications"
  value       = aws_sns_topic.cloudwatch_alarms.name
}
