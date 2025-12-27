data "aws_caller_identity" "current" {}

locals {
  enable_use1 = contains(var.replica_regions, "us-east-1")
}
resource "aws_kms_key" "dynamodb_mrk" {
  description             = "MRK for DynamoDB Global Table - ${var.table_name}"
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = true
  multi_region            = true

  tags = {
    Name = "${var.table_name}-dynamodb-mrk"
  }
}

data "aws_iam_policy_document" "dynamodb_kms_policy" {
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
}

resource "aws_kms_key_policy" "dynamodb_mrk_policy" {
  key_id = aws_kms_key.dynamodb_mrk.id
  policy = data.aws_iam_policy_document.dynamodb_kms_policy.json
}

resource "aws_kms_replica_key" "dynamodb_mrk_use1" {
  count           = local.enable_use1 ? 1 : 0
  provider        = aws.use1
  primary_key_arn = aws_kms_key.dynamodb_mrk.arn
  description     = "Replica MRK for DynamoDB Global Table - ${var.table_name} (us-east-1)"

  tags = {
    Name = "${var.table_name}-dynamodb-mrk-use1"
  }
}

resource "aws_kms_key_policy" "dynamodb_mrk_use1_policy" {
  count    = local.enable_use1 ? 1 : 0
  provider = aws.use1
  key_id   = aws_kms_replica_key.dynamodb_mrk_use1[0].id
  policy   = data.aws_iam_policy_document.dynamodb_kms_policy.json
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
    kms_key_arn = aws_kms_key.dynamodb_mrk.arn
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
    for_each = local.enable_use1 ? ["us-east-1"] : []
    content {
      region_name            = replica.value
      kms_key_arn            = aws_kms_replica_key.dynamodb_mrk_use1[0].arn
      point_in_time_recovery = true
      propagate_tags         = true
    }
  }

  tags = {
    Name = var.table_name
  }
}
