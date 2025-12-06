region = "eu-west-2"
common_tags = {
  Environment = "staging"
  ManagedBy   = "Terraform"
  Owner       = "Asli Aden"
  Project     = "Threat Composer App"
}

environment = "staging"

vpc_cidr_block             = "10.20.0.0/16"
private_subnet_cidr_blocks = ["10.20.1.0/24", "10.20.2.0/24"]
public_subnet_cidr_blocks  = ["10.20.101.0/24", "10.20.102.0/24"]
enable_dns_support         = true
enable_dns_hostnames       = true
vpc_flow_log_role_name     = "staging-vpc-flow-logs-role"

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
domain_name        = "staging.techwithaden.com"
aliases            = ["staging.techwithaden.com"]

# ALB / Target Group
target_group_name     = "staging-threat-model-tg"
target_group_port     = 80
target_group_protocol = "HTTP"
health_check_path     = "/"

dns_ttl            = 60
validation_timeout = "2h"

# ECS
cluster_name   = "staging-threat-model-cluster"
desired_count  = 1
container_name = "threat-model"
container_port = 3000
cpu            = "256"
memory         = "512"
cpu_target     = 50
min_capacity   = 1
max_capacity   = 2
family         = "staging-threat-model-task-family"
image_url      = "175798131198.dkr.ecr.eu-west-2.amazonaws.com/english-somali-dictionary-app:latest"
service_name   = "staging-threat-model-service"

# IAM
ecs_execution_role   = "staging-threat-model-execution-role"
ecs_execution_policy = "staging-threat-model-execution-policy"

# WAF
waf_name = "staging-threat-model-waf"
