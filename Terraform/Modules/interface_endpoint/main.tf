locals {
  endpoint_name_map = {
    for s in var.service_names : s => replace(replace(replace(s, "com.amazonaws.", ""), ".amazonaws.com", ""), ".", "-")
  }
}

data "aws_caller_identity" "current" {}

resource "aws_vpc_endpoint" "this" {
  for_each            = toset(var.service_names)
  vpc_id              = var.vpc_id
  service_name        = each.value
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids
  private_dns_enabled = var.private_dns_enabled
  ip_address_type     = var.ip_address_type

  tags = {
    Name        = "${var.environment}-${var.name_prefix}-${local.endpoint_name_map[each.key]}"
    ServiceName = each.value
  }
}

data "aws_iam_policy_document" "default_vpce_policy" {
  for_each = var.attach_policy && var.endpoint_policy_json == null ? aws_vpc_endpoint.this : {}

  statement {
    sid    = "AllowOnlyFromThisVPC"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions   = ["*"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceVpc"
      values   = [var.vpc_id]
    }

  }
}

resource "aws_vpc_endpoint_policy" "this" {
  for_each        = var.attach_policy ? aws_vpc_endpoint.this : {}
  vpc_endpoint_id = each.value.id
  policy          = var.endpoint_policy_json != null ? var.endpoint_policy_json : data.aws_iam_policy_document.default_vpce_policy[each.key].json
}
