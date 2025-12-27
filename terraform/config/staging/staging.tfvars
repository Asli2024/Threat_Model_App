region          = "eu-west-2"
replica_regions = ["us-east-1"]
common_tags = {
  Environment = "staging"
  ManagedBy   = "Terraform"
  Owner       = "Asli Aden"
  Project     = "English Somali Dictionary App"
}
environment                = "staging"
vpc_cidr_block             = "10.10.0.0/16"
private_subnet_cidr_blocks = ["10.10.1.0/24", "10.10.2.0/24"]
public_subnet_cidr_blocks  = ["10.10.101.0/24", "10.10.102.0/24"]
enable_dns_support         = true
enable_dns_hostnames       = true
vpc_flow_log_role_name     = "staging-vpc-flow-logs-role"
gateway_endpoints = [
  "com.amazonaws.eu-west-2.s3",
  "com.amazonaws.eu-west-2.dynamodb"
]
interface_endpoints = [
  "com.amazonaws.eu-west-2.ecr.api",
  "com.amazonaws.eu-west-2.ecr.dkr",
  "com.amazonaws.eu-west-2.logs",
  "com.amazonaws.eu-west-2.kms",
  "com.amazonaws.eu-west-2.elasticloadbalancing",
  "com.amazonaws.eu-west-2.monitoring",
  "com.amazonaws.eu-west-2.ecs",
  "com.amazonaws.eu-west-2.bedrock",
  "com.amazonaws.eu-west-2.bedrock-runtime"

]
ip_address_type       = "ipv4"
parent_domain_name    = "techwithaden.com"
domain_name           = "dictionary-staging.techwithaden.com"
aliases               = ["dictionary-staging.techwithaden.com"]
target_group_name     = "eng-somali-tg"
target_group_port     = 8000
target_group_protocol = "HTTP"
health_check_path     = "/api/health"
dns_ttl               = 60
validation_timeout    = "1h"
cluster_name          = "staging-english-somali-dictionary-cluster"
desired_count         = 2
container_port        = 8000
cpu                   = "256"
memory                = "512"
cpu_target            = 50
min_capacity          = 1
max_capacity          = 4
family                = "staging-english-somali-dictionary-task-family"
service_name          = "staging-english-somali-dictionary-service"
alarm_email           = ["ashleyaden4u@hotmail.com"]
