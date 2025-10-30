module "vpc" {
  source                     = "../Terraform/Modules/VPC"
  vpc_cidr_block             = var.vpc_cidr_block
  enable_dns_support         = var.enable_dns_support
  enable_dns_hostnames       = var.enable_dns_hostnames
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  vpc_flow_log_role_name     = "vpc-flow-logs-to-cloudwatch"
}

module "gateway_endpoints" {
  source          = "../Terraform/Modules/Gateway_Endpoint"
  vpc_id          = module.vpc.vpc_id
  service_name    = ["com.amazonaws.${var.region}.s3"]
  route_table_ids = [module.vpc.private_route_table_id]
}

module "interface_endpoints" {
  source = "../Terraform/Modules/Interface_Endpoint"
  vpc_id = module.vpc.vpc_id
  service_names = [
    "com.amazonaws.${var.region}.ecr.api",
    "com.amazonaws.${var.region}.ecr.dkr",
    "com.amazonaws.${var.region}.logs",
    "com.amazonaws.${var.region}.kms",
    "com.amazonaws.${var.region}.elasticloadbalancing",
    "com.amazonaws.${var.region}.monitoring",
    "com.amazonaws.${var.region}.ecs",
  ]
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [module.vpce_sg.security_group_id]
  private_dns_enabled = true
  ip_address_type     = "ipv4"

}

module "vpce_sg" {
  source         = "../Terraform/Modules/Security_Groups"
  vpc_id         = module.vpc.vpc_id
  sg_name        = "VPCE_SG"
  sg_description = "Security group for Interface VPC Endpoints (allow 443 from VPC)"

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
  source         = "../Terraform/Modules/Security_Groups"
  vpc_id         = module.vpc.vpc_id
  sg_name        = "ALB_SECURITY_GROUP"
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
  source         = "../Terraform/Modules/Security_Groups"
  vpc_id         = module.vpc.vpc_id
  sg_name        = "APP_SECURITY_GROUP"
  sg_description = "Application security group for ECS service"
  ingress_rules = [
    {
      from_port       = 3000
      to_port         = 3000
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

module "route53_new_zone" {
  source                 = "../Terraform/Modules/Route53"
  domain_name            = var.domain_name
  parent_domain_name     = var.parent_domain_name
  dns_name               = module.cloudfront.domain_name
  zone_id                = module.cloudfront.hosted_zone_id
  evaluate_target_health = false
}


module "alb" {
  source                = "../Terraform/Modules/ALB"
  vpc_id                = module.vpc.vpc_id
  security_group_id     = module.alb_sg.security_group_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  target_group_name     = "web-targets"
  target_group_port     = 3000
  target_group_protocol = "HTTP"
  health_check_path     = "/"
  acm_certificate_arn   = module.acm_alb.certificate_arn

}

module "acm_alb" {
  source             = "../Terraform/Modules/ACM"
  domain_name        = var.domain_name
  zone_id            = module.route53_new_zone.hosted_zone_id
  dns_ttl            = 60
  validation_timeout = "2h"
}

module "cloudfront" {
  source              = "../Terraform/Modules/Cloudfront"
  acm_certificate_arn = data.aws_acm_certificate.cloudfront_cert.arn
  aliases             = var.aliases
  alb_arn             = module.alb.alb_arn
  domain_name         = module.alb.alb_dns_name
  waf_acl             = module.waf_acl.waf_arn

}

module "ecs" {
  source                    = "../Terraform/Modules/ECS"
  subnet_ids                = module.vpc.private_subnet_ids
  security_group_id         = module.application_sg.security_group_id
  cluster_name              = "threat-model-cluster"
  desired_count             = 2
  container_name            = "threat-model-app"
  container_port            = 3000
  cpu                       = "256"
  memory                    = "512"
  cpu_target                = 50
  family                    = "threat-model-task-family"
  execution_role_arn        = module.ecs_execution_role.role_arn
  force_new_deployment      = true
  aws_kms_key_alias_ecs_log = "alias/ecs-log-key"
  task_role_arn             = module.task_role.role_arn
  target_group_arn          = module.alb.target_group_arn
  min_capacity              = 2
  max_capacity              = 3
  image                     = "${data.aws_ecr_image.app}:latest"
  region                    = var.region
  service_name              = "threat-model-service"
}

module "task_role" {
  source                 = "../Terraform/Modules/IAM"
  assume_role_policy     = data.aws_iam_policy_document.ecs_task_assume_role.json
  create_custom_policy   = true
  role_name              = "threat-composer-task-role"
  custom_policy_name     = "threat-composer-task-policy"
  custom_policy_document = data.aws_iam_policy_document.ecs_task_execution_policy.json
}

data "aws_iam_policy_document" "ecs_task_execution_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::threat-model-bucket",
      "arn:aws:s3:::threat-model-bucket/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:UpdateItem",
      "dynamodb:Scan",
      "dynamodb:Query"
    ]
    resources = [
      "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/ThreatModelTable"
    ]
  }
}

module "ecs_execution_role" {
  source                 = "../Terraform/Modules/IAM"
  role_name              = "threat-composer-ecs-execution-role"
  assume_role_policy     = data.aws_iam_policy_document.ecs_task_assume_role.json
  create_custom_policy   = true
  custom_policy_name     = "threat-composer-ecs-policy"
  custom_policy_document = data.aws_iam_policy_document.ecs_execution_policy.json
}

data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com", "ecs.amazonaws.com"]
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
      "ecr:BatchGetImage"
    ]
    resources = ["175798131198.dkr.ecr.eu-west-2.amazonaws.com/threat_model_app:latest"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:CreateLogGroup",
      "kms:*"
    ]
    resources = [
      "*"
    ]
  }
}

module "waf_acl" {
  source = "../Terraform/Modules/WAF"

  name        = "threat-model-waf-acl"
  description = "Web ACL for Threat Model"
  scope       = "CLOUDFRONT"
}
