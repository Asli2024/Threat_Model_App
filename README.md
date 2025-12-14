# Threat Model App

This project provides a production-ready deployment of the Threat Model App (English-Somali Dictionary) on AWS ECS Fargate, provisioned using Terraform and deployed through GitHub Actions. The FastAPI backend leverages **Amazon Bedrock** for advanced AI/ML capabilities, including real-time English-to-Somali translation, AI-powered text analysis, and secure, scalable inference using AWS-managed foundation models. Bedrock credentials and region are managed via environment variables or IAM roles, and the integration is handled in `english-dictionary/app/bedrock_client.py`.

The setup includes a multi-AZ VPC, secure HTTPS routing, scalable ECS tasks, an internal ALB, ACM-managed certificates, CloudFront distribution, WAF protection, customer-managed KMS keys, and automated CI/CD pipelines.

---

## Overview

This repository contains:
- **A FastAPI web application** for English-Somali translation, containerized with Docker.
- **Infrastructure as Code** using Terraform, modularized for AWS (ECS, ALB, VPC, Route53, CloudFront, WAF, IAM, etc).
- **CI/CD workflows** for building, scanning, planning, and deploying infrastructure and application code.

---

## Folder Structure

```

<details>
<summary><strong>Folder Structure</strong></summary>

```text
Threat_Model_App/
├── .gitignore
├── .pre-commit-config.yaml
├── README.md
├── Terraform/
│   ├── Modules/
│   │   ├── ACM/
│   │   ├── ALB/
│   │   ├── Cloudfront/
│   │   ├── ECS/
│   │   ├── Gateway_Endpoint/
│   │   ├── IAM/
│   │   ├── Interface_Endpoint/
│   │   ├── Route53/
│   │   ├── Security_Groups/
│   │   ├── VPC/
│   │   └── WAF/
│   ├── config/
│   │   ├── dev/
│   │   ├── prod/
│   │   └── staging/
│   ├── backend.tf
│   ├── data.tf
│   ├── main.tf
│   ├── provider.tf
│   ├── variables.tf
│   └── README.md
├── english-dictionary/
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
│   ├── Dockerfile
│   ├── requirements.txt
│   └── README.md
└── .github/
   └── workflows/
      ├── docker-build-push.yml
      ├── pr.yml
      ├── terraform-apply.yml
      ├── terraform-plan.yml
      ├── terraform-destroy-plan.yml
      └── terraform-destroy-apply.yml
```

</details>
## Local Development

### Prerequisites

- Python 3.11+
- Docker
- (Optional) Terraform CLI (for infrastructure work)
- (Optional) AWS CLI (for cloud operations)

### Running the FastAPI App Locally

1. **Clone the repository:**
   ```sh
   git clone https://github.com/Asli2024/Threat_Model_App.git
   cd Threat_Model_App/english-dictionary
   ```

2. **Install dependencies:**
   ```sh
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   ```

3. **Run the app:**
   ```sh
   uvicorn app.main:app --reload
   ```
   The API will be available at [http://localhost:8000](http://localhost:8000).

4. **(Optional) Run with Docker:**
   ```sh
   docker build -t english-dictionary .
   docker run -p 8000:8000 english-dictionary
   ```

5. **Frontend:**
   - Open `english-dictionary/static/index.html` in your browser for the UI.

---

## Infrastructure

- All infrastructure is managed with Terraform in the `Terraform/` directory.
- Modularized for best practices and reusability.
- See `Terraform/README.md` for module and provider details.

### Common Terraform Commands

```sh
cd Terraform
terraform init
terraform workspace select dev   # or staging/prod
terraform plan -var-file=config/dev/dev.tfvars
terraform apply -var-file=config/dev/dev.tfvars
```

---

## CI/CD

- Automated with GitHub Actions (`.github/workflows/`)
- Includes Docker build/scan, Terraform plan/apply, and destroy workflows
- Approval gates for production changes

---

## Contributing

1. Fork the repo and create your branch.
2. Make changes and add tests.
3. Open a pull request.

---

## License

MIT License

---
