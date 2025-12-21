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

<summary><strong>Folder Structure</strong></summary>

```text
English-Somali-Dictionary/
├── .gitignore
├── .pre-commit-config.yaml
├── README.md
├── Terraform/
│   ├── Modules/
│   │   ├── acm/
│   │   ├── alb/
│   │   ├── cloudfront/
│   │   ├── ecs/
│   │   ├── gateway_endpoint/
│   │   ├── iam/
│   │   ├── interface_endpoint/
│   │   ├── route53/
│   │   ├── security_groups/
│   │   ├── vpc/
│   │   └── waf/
│   ├── config/
│   │   ├── dev/
│   │   ├── staging/
│   │   └── prod/
│   ├── backend.tf
│   ├── provider.tf
│   ├── main.tf
│   ├── variables.tf
│   └── README.md
├── english-dictionary/
│   ├── app/
│   │   ├── __init__.py
│   │   ├── main.py
│   │   ├── bedrock_client.py
│   │   ├── config.py
│   │   └── prompts.py
│   ├── static/
│   │   ├── index.html
│   │   ├── app.js
│   │   └── styles.css
│   ├── Dockerfile
│   ├── requirements.txt
│   └── README.md
└── .github/
   └── workflows/
      ├── pr.yml
      ├── docker-build-push.yml
      ├── terraform-plan.yml
      ├── terraform-apply.yml
      ├── terraform-destroy-plan.yml
      └── terraform-destroy-apply.yml
```

---

## Local Development

### Prerequisites

* Python **3.11+**
* Docker
* (Optional) Terraform CLI
* (Optional) AWS CLI

---

### Run the API Locally (without DynamoDB)

1. **Clone the repository**

```bash
git clone https://github.com/Asli2024/English-Somali-Dictionary.git
cd English-Somali-Dictionary/english-dictionary
```

2. **Create and activate a virtual environment**

```bash
python3 -m venv venv
source venv/bin/activate
```

3. **Install dependencies**

```bash
pip install -r requirements.txt
```

4. **Run the application**

```bash
uvicorn app.main:app --reload
```

The API will be available at:
👉 [http://localhost:8000](http://localhost:8000)

---

### Run with Docker (Optional)

```bash
docker build -t english-dictionary .
docker run -p 8000:8000 english-dictionary
```

---

### Frontend

Open the UI directly in your browser:

```text
english-dictionary/static/index.html
```

---

## Infrastructure (Terraform)

All cloud infrastructure is defined using **Terraform** and lives in the `Terraform/` directory.

### Common Commands

```bash
cd Terraform
terraform init
terraform workspace select dev   # or staging / prod
terraform plan  -var-file=config/dev/dev.tfvars
terraform apply -var-file=config/dev/dev.tfvars
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
