# English-Somali Dictionary - Architecture Documentation

## Overview

This document describes the architecture and request flow for the English-Somali Dictionary application, a cloud-native translation service hosted on AWS.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                          CLIENT (User's Browser)                     │
│                     https://dev.techwithaden.com                     │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ HTTPS Request
                                    │ (Translation request)
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      Route 53 (DNS)                                  │
│  dev.techwithaden.com → CloudFront Distribution                     │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ Resolves to CloudFront
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    CloudFront Distribution                           │
│  - Global CDN Edge Locations                                        │
│  - TLS Termination (ACM Certificate us-east-1)                      │
│  - WAF Protection (Rate limiting, Geo-blocking)                     │
│  - Cache Policy (1 hour TTL)                                        │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ VPC Origin
                                    │ (Private connection to ALB)
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                           VPC (10.0.0.0/16)                         │
│  ┌───────────────────────────────────────────────────────────────┐ │
│  │        Application Load Balancer (Internal)                   │ │
│  │  - Private Subnets (10.0.3.0/24, 10.0.4.0/24)                │ │
│  │  - TLS Termination (ACM Certificate eu-west-2)               │ │
│  │  - Security Group: Allow 443 from CloudFront prefix list     │ │
│  │  - Target Group: Port 8000                                   │ │
│  │  - Health Check: /api/health                                 │ │
│  └───────────────────────────────────────────────────────────────┘ │
│                                    │                                 │
│                                    │ Forward to Target               │
│                                    ▼                                 │
│  ┌───────────────────────────────────────────────────────────────┐ │
│  │              ECS Fargate Service                              │ │
│  │  - 1-2 Tasks (ARM64)                                         │ │
│  │  - Private Subnets (10.0.3.0/24, 10.0.4.0/24)              │ │
│  │  - Container: english-somali-dictionary-app                  │ │
│  │  - Port 8000                                                 │ │
│  │  - Security Group: Allow 8000 from ALB                      │ │
│  │  - Auto-scaling based on CPU (50% target)                   │ │
│  └───────────────────────────────────────────────────────────────┘ │
│                                    │                                 │
│                                    │ API Request                     │
│                                    ▼                                 │
│  ┌───────────────────────────────────────────────────────────────┐ │
│  │         FastAPI Application Container                         │ │
│  │  - Python 3.11 Alpine                                        │ │
│  │  - FastAPI framework                                         │ │
│  │  - Routes: /api/translate, /api/health                       │ │
│  │  - CloudWatch Logs                                           │ │
│  └───────────────────────────────────────────────────────────────┘ │
│                                    │                                 │
│                                    │ Translation Request             │
│                                    │ (via VPC Endpoint)              │
│                                    ▼                                 │
│  ┌───────────────────────────────────────────────────────────────┐ │
│  │         VPC Endpoint: bedrock-runtime                         │ │
│  │  - Interface Endpoint (PrivateLink)                          │ │
│  │  - Private Subnets                                           │ │
│  │  - Security Group: Allow 443 from ECS                        │ │
│  │  - Service: com.amazonaws.eu-west-2.bedrock-runtime          │ │
│  └───────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ Private AWS Network
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                     AWS Bedrock (AI Service)                         │
│  - AI Translation Models                                             │
│  - Translates English ↔ Somali                                      │
│  - Returns translated text                                           │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ Translation Response
                                    ▼
                    ┌─────── Response flows back ───────┐
                    │    (Same path in reverse)         │
                    │ Bedrock → VPC Endpoint →          │
                    │ FastAPI → ECS → ALB →             │
                    │ CloudFront → Client               │
                    └───────────────────────────────────┘
```

## Request Flow Details

### 1. Client Request (Browser)

```
User enters: "Hello"
Browser sends: POST https://dev.techwithaden.com/api/translate
Body: {"text": "Hello", "source_lang": "en", "target_lang": "so"}
```

### 2. DNS Resolution (Route 53)

```
dev.techwithaden.com
  → CNAME: d1234abcd.cloudfront.net
  → CloudFront Distribution
```

### 3. CloudFront (Global CDN)

- Receives HTTPS request at nearest edge location
- Checks cache (1-hour TTL)
- If not cached, forwards to VPC Origin (ALB)
- WAF checks request (rate limits, geo-blocking)
- TLS termination (ACM certificate us-east-1)

### 4. Application Load Balancer (Internal)

- Receives request from CloudFront VPC Origin
- Security Group validates source (CloudFront prefix list)
- TLS re-encryption (ACM certificate eu-west-2)
- Health check ensures targets are healthy
- Routes to healthy ECS task on port 8000

### 5. ECS Fargate Task

- Receives HTTP request on port 8000
- FastAPI application processes request
- Calls /api/translate endpoint

### 6. FastAPI Application

```python
# Receives: POST /api/translate
# Validates: JSON body
# Calls: AWS Bedrock via boto3 client
# Connection: Uses VPC Endpoint (private)
```

### 7. VPC Endpoint (bedrock-runtime)

- Private connection (no internet)
- Routes to AWS Bedrock service
- Security Group allows 443 from ECS

### 8. AWS Bedrock

- Receives translation request
- Processes with AI model
- Returns translated text

### 9. Response Path (Reverse)

```
Bedrock → VPC Endpoint → ECS Task → ALB → CloudFront → Client

Client receives:
{
  "original_text": "Hello",
  "translated_text": "Salaan",
  "source_language": "en",
  "target_language": "so"
}
```

## Security Architecture

### Security Layers

1. **WAF (Web Application Firewall)**
   - Rate limiting
   - Geo-blocking
   - SQL injection protection
   - XSS protection

2. **CloudFront**
   - DDoS protection
   - TLS 1.2+ termination
   - Edge location caching
   - Origin access control

3. **Security Groups**
   - ALB: Allow 443 from CloudFront prefix list only
   - ECS: Allow 8000 from ALB security group only
   - VPC Endpoints: Allow 443 from ECS security group only

4. **Private Subnets**
   - No direct internet access
   - No NAT Gateway required
   - All AWS service communication via VPC Endpoints

5. **VPC Endpoints**
   - Private AWS service access
   - Services: ECR, CloudWatch Logs, Bedrock, ECS, ELB
   - No internet egress

6. **IAM Roles**
   - ECS Task Execution Role: Pull images, write logs
   - ECS Task Role: Call Bedrock API
   - Least privilege principle

## Network Architecture

### VPC Configuration

- **CIDR Block**: 10.0.0.0/16
- **Public Subnets**: 10.0.1.0/24, 10.0.2.0/24 (not used)
- **Private Subnets**: 10.0.3.0/24, 10.0.4.0/24 (application tier)
- **Availability Zones**: 2 AZs for high availability

### VPC Endpoints

All AWS service communication uses VPC Endpoints (PrivateLink):

- `com.amazonaws.eu-west-2.ecr.api`
- `com.amazonaws.eu-west-2.ecr.dkr`
- `com.amazonaws.eu-west-2.logs`
- `com.amazonaws.eu-west-2.kms`
- `com.amazonaws.eu-west-2.ecs`
- `com.amazonaws.eu-west-2.elasticloadbalancing`
- `com.amazonaws.eu-west-2.monitoring`
- `com.amazonaws.eu-west-2.translate`
- `com.amazonaws.eu-west-2.bedrock`
- `com.amazonaws.eu-west-2.bedrock-runtime`

### Zero Internet Egress

```
ECS Tasks (Private Subnets)
  → No NAT Gateway needed
  → All AWS services via VPC Endpoints
  → No internet-bound traffic
  → Enhanced security posture
```

## High Availability

### Multi-AZ Deployment

- ECS tasks distributed across 2 availability zones
- ALB targets in both AZs
- VPC Endpoints in both AZs
- Automatic failover

### Auto-Scaling

```
ECS Service:
- Min capacity: 1-2 tasks (environment dependent)
- Max capacity: 2-4 tasks (environment dependent)
- Scaling metric: CPU utilization
- Target: 50% CPU
- Scale-up: Add task when CPU > 50%
- Scale-down: Remove task when CPU < 50%
```

## Environments

### Dev Environment

- **URL**: https://dev.techwithaden.com
- **Tasks**: 1-2
- **Auto-scaling**: 1-2 tasks
- **Purpose**: Development and testing

### Staging Environment

- **URL**: https://staging.techwithaden.com
- **Tasks**: 1-2
- **Auto-scaling**: 1-2 tasks
- **Purpose**: Pre-production validation

### Prod Environment

- **URL**: https://techwithaden.com
- **Tasks**: 2
- **Auto-scaling**: 2-4 tasks
- **Purpose**: Production workloads

## Technology Stack

### Application

- **Language**: Python 3.11
- **Framework**: FastAPI
- **Container**: Alpine Linux (ARM64)
- **AI Service**: AWS Bedrock

### Infrastructure

- **IaC**: Terraform 1.10.4
- **State Management**: S3 backend with workspace prefix
- **Compute**: ECS Fargate (ARM64)
- **Load Balancer**: Application Load Balancer (Internal)
- **CDN**: CloudFront
- **DNS**: Route 53
- **Certificates**: AWS Certificate Manager
- **WAF**: AWS WAF v2
- **Logging**: CloudWatch Logs
- **Container Registry**: Amazon ECR

### CI/CD

- **Platform**: GitHub Actions
- **Workflows**:
  - PR validation (pre-commit, security scan, plan)
  - Manual deployment (plan → approval → apply)
  - State management (unlock)
- **Security**: Trivy scanning, pre-commit hooks
- **Authentication**: OIDC (GitHub → AWS)

## Monitoring & Observability

### CloudWatch Logs

- ECS task logs
- Application logs
- VPC flow logs

### CloudWatch Metrics

- ECS: CPU, Memory, Task count
- ALB: Request count, Response time, Error rates
- CloudFront: Cache hit rate, Error rates
- Custom: Bedrock API calls, Translation latency

### Planned: CloudWatch Dashboards

- Application health overview
- Request metrics
- CloudFront performance
- Bedrock AI metrics
- Error tracking

## Cost Optimization

1. **ARM64 Architecture**: Lower compute costs
2. **CloudFront Caching**: Reduced origin requests
3. **VPC Endpoints**: No NAT Gateway costs
4. **Fargate Spot** (future): Potential 70% cost reduction
5. **Auto-scaling**: Right-sized capacity

## Disaster Recovery

### Backup Strategy

- **Terraform State**: Versioned S3 bucket with encryption
- **Container Images**: Stored in ECR with image scanning
- **Infrastructure**: Fully codified in Terraform

### Recovery Process

1. Checkout Terraform code
2. Run `terraform apply` with appropriate workspace
3. ECS pulls latest container image from ECR
4. Application restored in minutes

### RTO/RPO

- **RTO (Recovery Time Objective)**: ~10 minutes
- **RPO (Recovery Point Objective)**: ~5 minutes

## Compliance & Security

- **Encryption in Transit**: TLS 1.2+ everywhere
- **Encryption at Rest**: All data encrypted (S3, CloudWatch Logs)
- **Network Isolation**: Private subnets, no internet access
- **Least Privilege**: IAM roles with minimal permissions
- **Audit Logging**: CloudWatch Logs, VPC Flow Logs
- **DDoS Protection**: CloudFront, WAF

## Future Enhancements

- [ ] CloudWatch Dashboards
- [ ] CloudWatch Alarms
- [ ] SNS notifications
- [ ] Cost anomaly detection
- [ ] Enhanced monitoring with X-Ray
- [ ] Fargate Spot for cost savings
- [ ] Multi-region deployment
- [ ] Database for translation history
- [ ] API rate limiting per user

---

**Last Updated**: December 2025
**Version**: 1.0
**Maintained by**: Asli Aden
