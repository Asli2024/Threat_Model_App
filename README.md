# English Somali Dictionary App

The **English–Somali Dictionary App** is a production-ready, cloud-native translation service built on **AWS ECS Fargate** and provisioned entirely using **Terraform**.
It provides real-time English-to-Somali translation using **Amazon Bedrock** foundation models, with optional caching via **DynamoDB** to improve performance and reduce inference costs.

The application is designed to run both:

* **Locally** (for development and testing, with DynamoDB optional), and
* **In AWS** (fully managed, secure, scalable, and highly available).

---

## Key Features

* **FastAPI backend** for real-time translation
* **Amazon Bedrock integration** for AI-powered English → Somali translation
* **Optional DynamoDB Global Table** for translation caching

  * Used in cloud deployments
  * Optional / disabled during local development
* **ECS Fargate** for serverless container orchestration
* **Internal Application Load Balancer (ALB)** fronted by **CloudFront**
* **AWS WAF** for edge protection
* **ACM-managed TLS certificates**
* **Customer-managed KMS keys** for encryption at rest
* **End-to-end CI/CD** with GitHub Actions
* **Terraform modules** following AWS and DevOps best practices

---

## Architecture Overview

At a high level, the system consists of:

* A **FastAPI container** running on ECS Fargate
* An **internal ALB** accessible only via CloudFront
* **CloudFront** providing HTTPS, caching control, and global access
* **Amazon Bedrock** for inference using managed foundation models
* **DynamoDB Global Table (optional)** for caching translations
* **VPC with private subnets**, VPC endpoints, and restricted network access
* **IAM roles with least privilege**
* **Observability** via CloudWatch dashboards and alarms

---

## DynamoDB Caching (Optional)

Translations can be cached in **DynamoDB** to:

* Reduce repeated calls to Amazon Bedrock
* Improve response latency
* Enable cross-region consistency via Global Tables

**Important:**

* DynamoDB is **optional for local development**
* When running locally, the application can operate **without DynamoDB**
* Configuration is handled via environment variables in:

  * `english-dictionary/app/config.py`
  * `english-dictionary/app/bedrock_client.py`

This allows fast iteration locally while keeping production optimized and cost-efficient.

---

## Repository Structure

```text
English-Somali-Dictionary/
├── english-dictionary/
│   ├── Dockerfile
│   ├── README.md
│   ├── requirements.txt
│   ├── app/
│   │   ├── __init__.py
│   │   ├── bedrock_client.py
│   │   ├── config.py
│   │   ├── main.py
│   │   └── prompts.py
│   ├── static/
│   │   ├── app.js
│   │   ├── index.html
│   │   └── styles.css
├── Terraform/
│   ├── backend.tf
│   ├── data.tf
│   ├── main.tf
│   ├── provider.tf
│   ├── variables.tf
│   ├── README.md
│   ├── config/
│   │   ├── dev/
│   │   │   └── dev.tfvars
│   │   ├── prod/
│   │   │   └── prod.tfvars
│   │   └── staging/
│   │       └── staging.tfvars
│   └── Modules/
│       ├── acm/
│       │   ├── main.tf
│       │   ├── output.tf
│       │   ├── provider.tf
│       │   ├── README.md
│       │   └── variables.tf
│       ├── alb/
│       │   ├── main.tf
│       │   ├── output.tf
│       │   ├── provider.tf
│       │   ├── README.md
│       │   └── variables.tf
│       ├── cloudfront/
│       │   ├── main.tf
│       │   ├── output.tf
│       │   ├── provider.tf
│       │   ├── README.md
│       │   └── variables.tf
│       ├── cloudwatch_alarm/
│       │   ├── main.tf
│       │   ├── output.tf
│       │   ├── provider.tf
│       │   ├── README.md
│       │   └── variables.tf
│       ├── cloudwatch_dashboard/
│       │   ├── main.tf
│       │   ├── output.tf
│       │   ├── provider.tf
│       │   ├── README.md
│       │   └── variables.tf
│       ├── dynamodb/
│       │   ├── main.tf
│       │   ├── output.tf
│       │   ├── provider.tf
│       │   ├── README.md
│       │   └── variables.tf
│       ├── ecs/
│       │   ├── data.tf
│       │   ├── main.tf
│       │   ├── output.tf
│       │   ├── provider.tf
│       │   ├── README.md
│       │   └── variables.tf
│       ├── gateway_endpoint/
│       │   ├── main.tf
│       │   ├── output.tf
│       │   ├── provider.tf
│       │   ├── README.md
│       │   └── variables.tf
│       ├── iam/
│       │   ├── main.tf
│       │   ├── output.tf
│       │   ├── provider.tf
│       │   ├── README.md
│       │   └── variables.tf
│       ├── interface_endpoint/
│       │   ├── data.tf
│       │   ├── main.tf
│       │   ├── output.tf
│       │   ├── provider.tf
│       │   ├── README.md
│       │   └── variables.tf
│       ├── route53/
│       │   ├── main.tf
│       │   ├── output.tf
│       │   ├── provider.tf
│       │   ├── README.md
│       │   └── variables.tf
│       ├── security_groups/
│       │   ├── main.tf
│       │   ├── output.tf
│       │   ├── provider.tf
│       │   ├── README.md
│       │   └── variables.tf
│       ├── vpc/
│       │   ├── data.tf
│       │   ├── main.tf
│       │   ├── output.tf
│       │   ├── provider.tf
│       │   ├── README.md
│       │   └── variables.tf
│       ├── waf/
│       │   ├── main.tf
│       │   ├── output.tf
│       │   ├── provider.tf
│       │   ├── README.md
│       │   └── variables.tf
├── .github/
│   └── workflows/
│       ├── docker-build-push.yml
│       ├── pr.yml
│       ├── terraform-apply.yml
│       ├── terraform-plan.yml
│       ├── terraform-destroy-plan.yml
│       └── terraform-destroy-apply.yml
├── .gitignore
├── .pre-commit-config.yaml
└── README.md
```

See `Terraform/README.md` for detailed module documentation.

---

## CI/CD

GitHub Actions workflows provide:

* Pre-commit validation
* Docker image build & scan
* Terraform plan/apply
* Environment-specific deployments
* Manual approval gates for production

Workflows are located in `.github/workflows/`.

---

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit changes with pre-commit checks passing
4. Open a pull request

---

## License

MIT License

---
