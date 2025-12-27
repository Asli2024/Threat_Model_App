locals {
  service_name_effective = length(trimspace(var.service_name)) > 0 ? var.service_name : (length(trimspace(var.family)) > 0 ? "${var.family}-service" : "ecs-service")
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_kms_key" "ecs_log_key" {
  description             = "KMS key for ECS log encryption"
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = true
}

resource "aws_kms_alias" "ecs_log_key_alias" {
  count         = var.aws_kms_key_alias_ecs_log == "" ? 0 : 1
  name          = trimspace(var.environment) != "" ? format("%s-%s", var.aws_kms_key_alias_ecs_log, var.environment) : var.aws_kms_key_alias_ecs_log
  target_key_id = aws_kms_key.ecs_log_key.id
}

resource "aws_kms_key_policy" "ecs_log_key_policy" {
  key_id = aws_kms_key.ecs_log_key.id
  policy = data.aws_iam_policy_document.ecs_log_kms_key_policy.json
}

data "aws_iam_policy_document" "ecs_log_kms_key_policy" {
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
    sid    = "AllowCloudWatchLogsUseOfKey"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["logs.${data.aws_region.current.id}.amazonaws.com"]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:CreateGrant",
      "kms:DescribeKey"
    ]
    resources = ["*"]
    condition {
      test     = "ArnLike"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values   = ["arn:aws:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:log-group:*"]
    }
  }

  statement {
    sid    = "AllowECSTasksToWriteLogs"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]
    resources = ["*"]
    condition {
      test     = "ArnLike"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values   = ["arn:aws:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:log-group:/ecs/*"]
    }
  }
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.family}"
  retention_in_days = 7
  kms_key_id        = aws_kms_key.ecs_log_key.arn
  depends_on        = [aws_kms_key_policy.ecs_log_key_policy]
}

resource "aws_ecs_service" "this" {
  name                 = local.service_name_effective
  cluster              = aws_ecs_cluster.this.id
  launch_type          = "FARGATE"
  desired_count        = var.desired_count
  task_definition      = aws_ecs_task_definition.this.arn
  force_new_deployment = var.force_new_deployment

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [var.security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  deployment_controller {
    type = "ECS"
  }

  depends_on = [aws_ecs_task_definition.this]
}

resource "aws_appautoscaling_target" "this" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
}

resource "aws_appautoscaling_policy" "cpu" {
  name               = "${local.service_name_effective}-cpu-autoscaling"
  service_namespace  = "ecs"
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = var.cpu_target
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  runtime_platform {
    cpu_architecture = "ARM64"
  }

  container_definitions = jsonencode([
    {
      name      = var.container_name,
      image     = var.image,
      essential = true,


      environment = [
        {
          name  = "AWS_REGION"
          value = var.region
        },
        {
          name  = "DYNAMODB_TABLE_NAME"
          value = var.dynamodb_table_name
        },
        {
          name  = "DYNAMODB_REGION"
          value = var.region
        },
        {
          name  = "MODEL_ID"
          value = var.bedrock_model_id
        },
        {
          name  = "BEDROCK_MAX_OUTPUT_LENGTH"
          value = tostring(var.max_tokens)
        },
        {
          name  = "TEMPERATURE"
          value = tostring(var.temperature)
        },
        {
          name  = "TOP_P"
          value = tostring(var.top_p)
        },
        {
          name  = "APP_NAME"
          value = "Somali Dictionary API"
        },
        {
          name  = "DEBUG"
          value = "false"
        }
      ],

      portMappings = [{
        containerPort = var.container_port,
        hostPort      = var.container_port
      }],

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "/ecs/${var.family}",
          awslogs-region        = var.region,
          awslogs-stream-prefix = var.container_name
        }
      }
    }
  ])

  depends_on = [aws_cloudwatch_log_group.ecs_log_group]
}
