region = "eu-west-2"
common_tags = {
  Environment = "prod"
  ManagedBy   = "Terraform"
  Owner       = "Asli Aden"
  Project     = "Threat Composer App"
}

environment = "prod"

vpc_cidr_block             = "10.30.0.0/16"
private_subnet_cidr_blocks = ["10.30.1.0/24", "10.30.2.0/24"]
public_subnet_cidr_blocks  = ["10.30.101.0/24", "10.30.102.0/24"]
enable_dns_support         = true
enable_dns_hostnames       = true
vpc_flow_log_role_name     = "prod-vpc-flow-logs-role"

gateway_endpoints = ["com.amazonaws.eu-west-2.s3"]
interface_endpoints = [
  "com.amazonaws.eu-west-2.ecr.api",
  "com.amazonaws.eu-west-2.ecr.dkr",
  "com.amazonaws.eu-west-2.logs",
  "com.amazonaws.eu-west-2.kms",
  "com.amazonaws.eu-west-2.elasticloadbalancing",
  "com.amazonaws.eu-west-2.monitoring",
  "com.amazonaws.eu-west-2.ecs",
]
ip_address_type = "ipv4"

parent_domain_name = "techwithaden.com"
domain_name        = "techwithaden.com"
aliases            = ["techwithaden.com"]

# ALB / Target Group
target_group_name     = "prod-threat-model-tg"
target_group_port     = 80
target_group_protocol = "HTTP"
health_check_path     = "/"

dns_ttl            = 60
validation_timeout = "2h"

# ECS
cluster_name   = "prod-threat-model-cluster"
desired_count  = 2
container_name = "threat-model"
container_port = 3000
cpu            = "256"
memory         = "512"
cpu_target     = 50
min_capacity   = 2
max_capacity   = 4
family         = "prod-threat-model-task-family"
image_url      = "175798131198.dkr.ecr.eu-west-2.amazonaws.com/english-somali-dictionary-app:latest"
service_name   = "prod-threat-model-service"

# IAM
ecs_execution_role   = "prod-threat-model-execution-role"
ecs_execution_policy = "prod-threat-model-execution-policy"

# WAF
waf_name = "prod-threat-model-wafs"
