# English Somali Dictionary App

The **English Somali Dictionary App** is a production-ready, cloud-native translation service built on **AWS ECS Fargate** and provisioned entirely using **Terraform**.

It provides real-time English → Somali translation using **Amazon Bedrock** foundation models, with **optional DynamoDB caching** to improve performance and reduce inference costs.

The application is designed to run in two modes:

* **Local development** – fast iteration, minimal dependencies, DynamoDB optional
* **AWS production** – fully managed, secure, scalable, and highly available

---

## Key Features

* **FastAPI backend** for real-time translation APIs
* **Amazon Bedrock integration** for AI-powered English → Somali translation
* **Optional DynamoDB Global Table** for translation caching

  * Enabled in cloud deployments
  * Disabled by default for local development
* **ECS Fargate** for serverless container orchestration
* **Internal Application Load Balancer (ALB)** fronted by **CloudFront**
* **AWS WAF** for edge protection
* **ACM-managed TLS certificates**
* **Customer-managed KMS keys** for encryption at rest
* **End-to-end CI/CD** with GitHub Actions
* **Modular Terraform architecture** following AWS and DevOps best practices

---

## Architecture Overview

At a high level, the system consists of:

* A **FastAPI container** running on ECS Fargate
* An **internal ALB** that is not publicly accessible
* **CloudFront** providing HTTPS termination, request routing, and caching control
* **Amazon Bedrock** for inference using managed foundation models
* **DynamoDB Global Table (optional)** for caching translation results
* A **VPC with private subnets**, VPC endpoints, and restricted network access
* **IAM roles with least-privilege permissions**
* **Observability** via CloudWatch dashboards and alarms

---

## DynamoDB Caching (Optional)

Translations can be cached in **DynamoDB** to:

* Reduce repeated calls to Amazon Bedrock
* Improve response latency
* Enable cross-region consistency using Global Tables

### Important Notes

* DynamoDB is **optional for local development**
* When running locally, the application can operate **without DynamoDB**
* Caching behaviour is controlled via environment variables defined in:

  * `english-dictionary/app/config.py`
  * `english-dictionary/app/bedrock_client.py`

This approach allows fast local iteration while keeping production deployments optimized and cost-efficient.

---

## Repository Structure

```text
English-Somali-Dictionary/
├── README.md
│
├── Terraform/
│   ├── README.md
│   ├── backend.tf
│   ├── provider.tf
│   ├── data.tf
│   ├── main.tf
│   ├── variables.tf
│   │
│   ├── config/
│   │   ├── dev/
│   │   ├── prod/
│   │   └── staging/
│   │
│   └── Modules/
│       ├── acm/
│       ├── alb/
│       ├── cloudfront/
│       ├── cloudwatch_alarm/
│       ├── cloudwatch_dashboard/
│       ├── dynamodb/
│       ├── ecs/
│       ├── gateway_endpoint/
│       ├── iam/
│       ├── interface_endpoint/
│       ├── route53/
│       ├── security_groups/
│       ├── vpc/
│       └── waf/
│
└── english-dictionary/
    ├── Dockerfile
    ├── README.md
    ├── requirements.txt
    │
    ├── app/
    │   ├── __init__.py
    │   ├── main.py
    │   ├── bedrock_client.py
    │   ├── config.py
    │   └── prompts.py
    │
    └── static/
        ├── index.html
        ├── app.js
        └── styles.css
```


---

## CI/CD

GitHub Actions workflows provide:

* Pre-commit validation
* Docker image build and security scanning
* Terraform plan and apply per environment
* Environment-specific deployments
* Manual approval gates for production

All workflows are located in `.github/workflows/`.

---

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit changes with pre-commit checks passing
4. Open a pull request

---
