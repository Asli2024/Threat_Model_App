data "aws_caller_identity" "current" {}

resource "aws_kms_key" "sns_key" {
  description             = "KMS key for SNS topic encryption (${var.environment}-cloudwatch-alarms)"
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = true

  policy = data.aws_iam_policy_document.sns_kms_key_policy.json

  tags = {
    Environment = var.environment
    Purpose     = "SNS encryption for CloudWatch alarms"
  }
}

resource "aws_kms_alias" "sns_key_alias" {
  name          = "alias/${var.environment}/cloudwatch-alarms-sns"
  target_key_id = aws_kms_key.sns_key.key_id
}

data "aws_iam_policy_document" "sns_kms_key_policy" {

  statement {
    sid    = "EnableRootPermissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid    = "AllowSNSUseOfKey"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]
    resources = ["*"]
  }
}

resource "aws_sns_topic" "cloudwatch_alarms" {
  name              = "${var.environment}-cloudwatch-alarms"
  kms_master_key_id = aws_kms_key.sns_key.arn

  tags = {
    Purpose = "CloudWatch alarms"
  }
}


resource "aws_sns_topic_subscription" "alarm_email" {
  topic_arn = aws_sns_topic.cloudwatch_alarms.arn
  protocol  = "email"
  endpoint  = join(",", var.alarm_email)
}

resource "aws_cloudwatch_metric_alarm" "alb_target_5xx" {
  alarm_name          = "${var.environment}-alb-target-5xx"
  alarm_description   = "ALB target returned 5XX errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alb_5xx_evaluation_periods
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = var.alb_5xx_period_seconds
  statistic           = "Sum"
  threshold           = var.alb_5xx_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
    TargetGroup  = var.target_group_arn_suffix
  }

  alarm_actions = [aws_sns_topic.cloudwatch_alarms.arn]
}

resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_hosts" {
  alarm_name          = "${var.environment}-alb-unhealthy-hosts"
  alarm_description   = "One or more targets are unhealthy"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.alb_unhealthy_evaluation_periods
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = var.alb_unhealthy_period_seconds
  statistic           = "Average"
  threshold           = var.alb_unhealthy_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
    TargetGroup  = var.target_group_arn_suffix
  }

  alarm_actions = [aws_sns_topic.cloudwatch_alarms.arn]
}

resource "aws_cloudwatch_metric_alarm" "alb_target_response_time" {
  alarm_name          = "${var.environment}-alb-target-response-time"
  alarm_description   = "ALB target response time is high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alb_latency_evaluation_periods
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = var.alb_latency_period_seconds
  statistic           = "Average"
  threshold           = var.alb_latency_threshold_seconds
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
    TargetGroup  = var.target_group_arn_suffix
  }

  alarm_actions = [aws_sns_topic.cloudwatch_alarms.arn]
}

resource "aws_cloudwatch_metric_alarm" "ecs_running_tasks_low" {
  alarm_name          = "${var.environment}-ecs-running-tasks-low"
  alarm_description   = "ECS running tasks less than desired"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.ecs_tasks_evaluation_periods
  metric_name         = "RunningTaskCount"
  namespace           = "AWS/ECS"
  period              = var.ecs_tasks_period_seconds
  statistic           = "Average"
  threshold           = var.desired_count
  treat_missing_data  = "breaching"

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = var.service_name
  }

  alarm_actions = [aws_sns_topic.cloudwatch_alarms.arn]
}

resource "aws_cloudwatch_metric_alarm" "dynamodb_throttles" {
  alarm_name          = "${var.environment}-dynamodb-throttled"
  alarm_description   = "DynamoDB requests are being throttled"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.ddb_throttle_evaluation_periods
  metric_name         = "ThrottledRequests"
  namespace           = "AWS/DynamoDB"
  period              = var.ddb_throttle_period_seconds
  statistic           = "Sum"
  threshold           = var.ddb_throttle_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    TableName = var.dynamodb_table_name
  }

  alarm_actions = [aws_sns_topic.cloudwatch_alarms.arn]
}

resource "aws_cloudwatch_metric_alarm" "dynamodb_system_errors" {
  alarm_name          = "${var.environment}-dynamodb-system-errors"
  alarm_description   = "DynamoDB SystemErrors > 0"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.ddb_system_error_evaluation_periods
  metric_name         = "SystemErrors"
  namespace           = "AWS/DynamoDB"
  period              = var.ddb_system_error_period_seconds
  statistic           = "Sum"
  threshold           = var.ddb_system_error_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    TableName = var.dynamodb_table_name
  }

  alarm_actions = [aws_sns_topic.cloudwatch_alarms.arn]
}
