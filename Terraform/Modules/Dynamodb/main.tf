data "aws_caller_identity" "current" {}
resource "aws_kms_key" "dynamodb_table_key" {
  description             = "KMS key for DynamoDB table encryption - ${var.table_name}"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name = "${var.table_name}-dynamodb-kms-key"
  }
}

resource "aws_kms_key_policy" "aws_dynamodb_table_key_policy" {
  key_id = aws_kms_key.dynamodb_table_key.id
  policy = data.aws_iam_policy_document.dynamodb_table_kms_key_policy.json
}

data "aws_iam_policy_document" "dynamodb_table_kms_key_policy" {
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
    sid    = "AllowDynamoDBUseOfKey"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["dynamodb.amazonaws.com"]
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
  }

  statement {
    sid    = "AllowECSTaskRole"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.ecs_task_role_name}"]
    }
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:GenerateDataKey"
    ]
    resources = [
      "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/dictionary-words-${var.environment}",
      "arn:aws:dynamodb:us-east-1:${data.aws_caller_identity.current.account_id}:table/dictionary-words-${var.environment}"
    ]
  }
}

resource "aws_dynamodb_table" "dictionary_words" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "word"

  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.dynamodb_table_key.arn
  }

  attribute {
    name = "word"
    type = "S"
  }

  ttl {
    attribute_name = "expiration_time"
    enabled        = true
  }

  dynamic "replica" {
    for_each = var.replica_regions
    content {
      region_name            = replica.value
      point_in_time_recovery = true
      propagate_tags         = true
    }
  }

  tags = {
    Name = var.table_name
  }
}
