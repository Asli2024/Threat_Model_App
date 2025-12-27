module "vpc" {
  source                     = "../terraform/modules/vpc"
  vpc_cidr_block             = var.vpc_cidr_block
  enable_dns_support         = var.enable_dns_support
  enable_dns_hostnames       = var.enable_dns_hostnames
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  vpc_flow_log_role_name     = "${var.environment}-${var.vpc_flow_log_role_name}"
  environment                = var.environment
  name_prefix                = var.environment
}

module "gateway_endpoints" {
  source          = "../terraform/modules/gateway_endpoint"
  vpc_id          = module.vpc.vpc_id
  service_names   = var.gateway_endpoints
  route_table_ids = [module.vpc.private_route_table_id]
  name_prefix     = var.environment
}

module "interface_endpoints" {
  source              = "../terraform/modules/interface_endpoint"
  vpc_id              = module.vpc.vpc_id
  service_names       = var.interface_endpoints
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [module.vpce_sg.security_group_id]
  private_dns_enabled = true
  ip_address_type     = var.ip_address_type
  environment         = var.environment
}

module "vpce_sg" {
  source         = "../terraform/modules/security_groups"
  vpc_id         = module.vpc.vpc_id
  sg_name        = "${var.environment}-VPCE-SG"
  sg_description = "Security group for Interface VPC Endpoints"
  ingress_rules = [
    {
      from_port       = 443
      to_port         = 443
      protocol        = "tcp"
      cidr_blocks     = [var.vpc_cidr_block]
      security_groups = []
      prefix_list_ids = []
      description     = "Allow HTTPS from within VPC"
    }
  ]

  egress_rules = [
    {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      cidr_blocks     = ["0.0.0.0/0"]
      security_groups = []
      prefix_list_ids = []
      description     = "Allow all egress"
    }
  ]
}

module "alb_sg" {
  source         = "../terraform/modules/security_groups"
  vpc_id         = module.vpc.vpc_id
  sg_name        = "${var.environment}-ALB-SG"
  sg_description = "ALB security group"
  ingress_rules = [
    {
      from_port       = 443
      to_port         = 443
      protocol        = "tcp"
      cidr_blocks     = []
      security_groups = []
      prefix_list_ids = [data.aws_ec2_managed_prefix_list.cf_origin.id]
      description     = "Allow HTTPS from CloudFront origin-facing"
    }
  ]

  egress_rules = [
    {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      cidr_blocks     = ["0.0.0.0/0"]
      security_groups = []
      prefix_list_ids = []
      description     = "Allow all outbound traffic"
    }
  ]
}

module "application_sg" {
  source         = "../terraform/modules/security_groups"
  vpc_id         = module.vpc.vpc_id
  sg_name        = "${var.environment}-APP-SG"
  sg_description = "Application security group for ECS service"
  ingress_rules = [
    {
      from_port       = var.container_port
      to_port         = var.container_port
      protocol        = "tcp"
      security_groups = [module.alb_sg.security_group_id]
      cidr_blocks     = []
      prefix_list_ids = []
      description     = "Allow traffic from ALB"

    }

  ]
  egress_rules = [
    {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      cidr_blocks     = ["0.0.0.0/0"]
      security_groups = []
      prefix_list_ids = []
      description     = "Allow all outbound traffic within the VPC"
    }

  ]
}

module "cloudfront" {
  source              = "../terraform/modules/cloudfront"
  acm_certificate_arn = data.aws_acm_certificate.cloudfront_cert.arn
  aliases             = var.aliases

  alb_arn     = module.alb.alb_arn
  domain_name = module.alb.alb_dns_name
  waf_acl     = module.waf_acl.waf_arn
  price_class = "PriceClass_100"
}

module "route53_new_zone" {
  source                 = "../terraform/modules/route53"
  domain_name            = var.domain_name
  parent_domain_name     = var.parent_domain_name
  dns_name               = module.cloudfront.domain_name
  zone_id                = module.cloudfront.hosted_zone_id
  evaluate_target_health = false
}

module "alb" {
  source                = "../terraform/modules/alb"
  vpc_id                = module.vpc.vpc_id
  security_group_id     = module.alb_sg.security_group_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  target_group_name     = "${var.environment}-${var.target_group_name}"
  target_group_port     = var.target_group_port
  target_group_protocol = var.target_group_protocol
  health_check_path     = var.health_check_path
  acm_certificate_arn   = module.acm_alb.certificate_arn
  environment           = var.environment
}

module "acm_alb" {
  source             = "../terraform/modules/acm"
  domain_name        = var.domain_name
  zone_id            = module.route53_new_zone.hosted_zone_id
  dns_ttl            = var.dns_ttl
  validation_timeout = var.validation_timeout
}

module "ecs" {
  source                    = "../terraform/modules/ecs"
  subnet_ids                = module.vpc.private_subnet_ids
  security_group_id         = module.application_sg.security_group_id
  cluster_name              = var.cluster_name
  desired_count             = var.desired_count
  container_name            = "english-somali-dictionary-app-${var.environment}"
  container_port            = var.container_port
  cpu                       = var.cpu
  memory                    = var.memory
  cpu_target                = var.cpu_target
  family                    = var.family
  execution_role_arn        = module.ecs_execution_role.role_arn
  task_role_arn             = module.ecs_task_role.role_arn
  force_new_deployment      = true
  aws_kms_key_alias_ecs_log = "alias/ecs-log-key-${var.environment}"
  target_group_arn          = module.alb.target_group_arn
  min_capacity              = var.min_capacity
  max_capacity              = var.max_capacity
  image                     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/english-somali-dictionary-app@${data.aws_ecr_image.app_image.image_digest}"
  region                    = var.region
  service_name              = var.service_name
  environment               = var.environment
  dynamodb_table_name       = "dictionary-words-${var.environment}"
  bedrock_model_id          = var.bedrock_model_id
  temperature               = 0.3
  top_p                     = 0.9
  max_tokens                = var.max_tokens
}

module "ecs_execution_role" {
  source                 = "../terraform/modules/iam"
  role_name              = "${var.environment}-ecs-execution-roles"
  assume_role_policy     = data.aws_iam_policy_document.ecs_execution_assume_role.json
  create_custom_policy   = true
  custom_policy_name     = "${var.environment}-ecs-execution-policy"
  custom_policy_document = data.aws_iam_policy_document.ecs_execution_policy.json
}

data "aws_iam_policy_document" "ecs_execution_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "ecs_execution_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:DescribeRepositories"
    ]
    resources = [
      "arn:aws:ecr:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:repository/english-somali-dictionary-app"
    ]
  }

  statement {
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = [
      module.ecs.cloudwatch_log_group_arn,
      "${module.ecs.cloudwatch_log_group_arn}:log-stream:*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey"
    ]
    resources = [module.ecs.kms_key_arn]
  }
}

module "ecs_task_role" {
  source                 = "../terraform/modules/iam"
  role_name              = "${var.environment}-dictionary-task-role"
  assume_role_policy     = data.aws_iam_policy_document.ecs_execution_assume_role.json
  create_custom_policy   = true
  custom_policy_name     = "${var.environment}-translate-policy"
  custom_policy_document = data.aws_iam_policy_document.translate_policy.json
}

data "aws_iam_policy_document" "translate_policy" {
  statement {
    effect = "Allow"
    actions = [
      "bedrock:InvokeModel",
      "bedrock:InvokeModelWithResponseStream"
    ]

    resources = [
      "arn:aws:bedrock:${var.region}::foundation-model/${var.bedrock_model_id}"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem"
    ]

    resources = [

      "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/dictionary-words-${var.environment}",
      "arn:aws:dynamodb:us-east-1:${data.aws_caller_identity.current.account_id}:table/dictionary-words-${var.environment}"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:GenerateDataKey"
    ]

    resources = compact([
      module.dynamodb.kms_key_arn,
      module.dynamodb.kms_replica_key_arn_use1
    ])

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values = [
        "dynamodb.${var.region}.amazonaws.com",
        "dynamodb.us-east-1.amazonaws.com"
      ]
    }
  }
}

module "waf_acl" {
  source = "../terraform/modules/waf"
  providers = {
    aws = aws.use1
  }
  name        = "${var.environment}-waf-acl"
  description = "Web ACL for Dictionary App - ${var.environment}"
}

module "dynamodb" {
  source          = "../terraform/modules/dynamodb"
  table_name      = "dictionary-words-${var.environment}"
  replica_regions = var.replica_regions
}

module "cloudwatch_dashboard" {
  source = "../terraform/modules/cloudwatch_dashboard"

  dashboard_name          = "${var.environment}-dictionary-dashboards"
  region                  = var.region
  cluster_name            = var.cluster_name
  service_name            = var.service_name
  alb_arn_suffix          = module.alb.alb_arn_suffix
  target_group_arn_suffix = module.alb.target_group_arn_suffix
  dynamodb_table_name     = "dictionary-words-${var.environment}"

}

module "cloudwatch_alarms" {
  source      = "../terraform/modules/cloudwatch_alarm"
  environment = var.environment
  alarm_email = var.alarm_email

  cluster_name  = var.cluster_name
  service_name  = var.service_name
  desired_count = var.desired_count

  alb_arn_suffix          = module.alb.alb_arn_suffix
  target_group_arn_suffix = module.alb.target_group_arn_suffix

  dynamodb_table_name = "dictionary-words-${var.environment}"

}
