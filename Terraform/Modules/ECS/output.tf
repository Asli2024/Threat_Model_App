output "ecs_cluster_id" {
  description = "The ID of the ECS cluster"
  value       = aws_ecs_cluster.this.id
}

output "ecs_service_name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.this.name
}

output "task_definition_arn" {
  description = "The full ARN of the ECS task definition"
  value       = aws_ecs_task_definition.this.arn
}

output "container_name" {
  description = "The name of the container used in the task definition"
  value       = var.container_name
}

output "autoscaling_policy_name" {
  value = aws_appautoscaling_policy.cpu.name
}

output "kms_key_id" {
  value       = aws_kms_key.ecs_log_key.id
  description = "KMS Key ID for ECS log encryption"
}

output "kms_key_arn" {
  value       = aws_kms_key.ecs_log_key.arn
  description = "KMS Key ARN for ECS log encryption"
}

output "kms_key_alias_name" {
  value       = aws_kms_alias.ecs_log_key_alias.name
  description = "KMS Key Alias for ECS log encryption"
}
