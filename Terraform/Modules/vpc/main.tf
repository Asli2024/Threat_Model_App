locals {
  public_subnets = {
    for i, cidr in var.public_subnet_cidr_blocks :
    "public-${i}" => {
      cidr = cidr
      az   = data.aws_availability_zones.available.names[i]
    }
  }
  private_subnets = {
    for i, cidr in var.private_subnet_cidr_blocks :
    "private-${i}" => {
      cidr = cidr
      az   = data.aws_availability_zones.available.names[i]
    }
  }
}

data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name = var.name_prefix != "" ? "${var.name_prefix}-vpc" : "vpc"
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = var.name_prefix != "" ? "${var.name_prefix}-igw" : "igw"
  }
}

resource "aws_subnet" "public_subnet" {
  for_each                = local.public_subnets
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name = var.name_prefix != "" ? "${var.name_prefix}-${each.key}" : each.key
  }
}

resource "aws_subnet" "private_subnet" {
  for_each          = local.private_subnets
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = var.name_prefix != "" ? "${var.name_prefix}-${each.key}" : each.key
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = var.name_prefix != "" ? "${var.name_prefix}-public-rt" : "public-rt"
  }
}

resource "aws_route_table_association" "public_rt_association" {
  for_each       = local.public_subnets
  subnet_id      = aws_subnet.public_subnet[each.key].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route" "public_internet_gateway_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.IGW.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = var.name_prefix != "" ? "${var.name_prefix}-private-rt" : "private-rt"
  }
}

resource "aws_route_table_association" "private_rt_association" {
  for_each       = local.private_subnets
  subnet_id      = aws_subnet.private_subnet[each.key].id
  route_table_id = aws_route_table.private_rt.id
}

data "aws_iam_policy_document" "vpc_flow_logs_kms_default" {
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
      identifiers = ["logs.${data.aws_region.current.id}.amazonaws.com"] # Changed from .id to .name
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
      values   = ["arn:aws:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:log-group:*"] # Changed and fixed wildcard
    }
  }
}

data "aws_iam_policy_document" "vpc_flow_logs_assume_default" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "vpc_flow_logs_role_default" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    resources = ["*"]
  }
}

resource "aws_kms_key" "vpc_flow_logs" {
  description         = "KMS key for VPC Flow Logs (CloudWatch Logs encryption)"
  enable_key_rotation = true
  policy              = var.vpc_flow_log_kms_key_policy_json != "" ? var.vpc_flow_log_kms_key_policy_json : data.aws_iam_policy_document.vpc_flow_logs_kms_default.json

  tags = {
    Name = var.name_prefix != "" ? "${var.name_prefix}-flow-logs-kms" : "flow-logs-kms"
  }
}

resource "aws_kms_alias" "vpc_flow_logs" {
  name          = trimspace(var.environment) != "" ? "alias/vpc-flow-logs-key-${var.environment}" : "alias/vpc-flow-logs-key"
  target_key_id = aws_kms_key.vpc_flow_logs.id
}

resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = trimspace(var.environment) != "" ? "/aws/vpc/flow-logs/${var.environment}" : "/aws/vpc/flow-logs"
  retention_in_days = 7
  kms_key_id        = aws_kms_key.vpc_flow_logs.arn
  depends_on        = [aws_kms_alias.vpc_flow_logs]

  tags = {
    Name = var.name_prefix != "" ? "${var.name_prefix}-flow-logs" : "flow-logs"
  }
}

resource "aws_iam_role" "flow_log_role" {
  name               = var.vpc_flow_log_role_name
  assume_role_policy = var.vpc_flow_logs_assume_role != "" ? var.vpc_flow_logs_assume_role : data.aws_iam_policy_document.vpc_flow_logs_assume_default.json

  tags = {
    Name = var.name_prefix != "" ? "${var.name_prefix}-flow-logs-role" : "flow-logs-role"
  }
}

resource "aws_iam_role_policy" "vpc_flow_logs_to_cw" {
  name   = "vpc-flow-logs-to-cloudwatch"
  role   = aws_iam_role.flow_log_role.id
  policy = var.vpc_flow_log_role_policy_json != "" ? var.vpc_flow_log_role_policy_json : data.aws_iam_policy_document.vpc_flow_logs_role_default.json
}

resource "aws_flow_log" "main" {
  vpc_id               = aws_vpc.main_vpc.id
  log_destination_type = "cloud-watch-logs"
  log_destination      = aws_cloudwatch_log_group.vpc_flow_logs.arn
  iam_role_arn         = aws_iam_role.flow_log_role.arn
  traffic_type         = "ALL"
  depends_on           = [aws_cloudwatch_log_group.vpc_flow_logs]

  tags = {
    Name = var.name_prefix != "" ? "${var.name_prefix}-vpc-flow-log" : "vpc-flow-log"
  }
}
