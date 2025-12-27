data "aws_caller_identity" "current" {}

#tfsec:ignore:AVD-AWS-0089 Logging is not required for all S3 buckets in this use case
module "s3" {
  source             = "../terraform/modules/s3"
  prefix             = var.prefix
  environment        = var.environment
  uploader_role_name = module.iam_oidc_role.role_name
  aws_region         = var.region
}

module "iam_oidc_role" {
  source                 = "../terraform/modules/iam"
  role_name              = "github-oidc-role"
  assume_role_policy     = data.aws_iam_policy_document.oidc_assume_role.json
  create_custom_policy   = true
  custom_policy_name     = "${var.environment}-oidc-policy"
  custom_policy_document = data.aws_iam_policy_document.oidc_policy.json
}

data "aws_iam_policy_document" "oidc_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:Asli2024/English-Somali-Dictionary:*"]
    }
  }
}

#tfsec:ignore:AVD-AWS-0345 Allowing all actions on all resources for OIDC role used by GitHub Actions for deployment
data "aws_iam_policy_document" "oidc_policy" {
  statement {
    effect = "Allow"
    actions = [
      "acm:*",
      "application-autoscaling:*",
      "autoscaling:*",
      "bedrock:*",
      "cloudfront:*",
      "cloudwatch:*",
      "dynamodb:*",
      "ec2:*",
      "ecr:*",
      "ecs:*",
      "elasticloadbalancing:*",
      "iam:*",
      "kms:*",
      "logs:*",
      "route53:*",
      "s3:*",
      "sns:*",
      "sts:*",
      "wafv2:*",
    ]
    resources = [
      "*"
    ]
  }
}

module "ecr" {
  source          = "../terraform/modules/ecr"
  repository_name = "${var.prefix}-ecr-repo"
}
