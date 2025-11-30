# Multi-Language Dictionary App

A FastAPI-based translation application using AWS Translate.

## Features
- 🌍 Supports 4 languages: Somali, French, Spanish, Arabic
- 🔒 Secure AWS Translate integration
- 🌙 Dark/Light mode UI
- 🐳 Docker containerized
- 📦 Optimized Docker image (163MB)

## Files Included

```
.
├── app/                    # Backend application code
│   ├── __init__.py
│   ├── config.py          # Settings and AWS configuration
│   ├── main.py            # FastAPI application
│   └── services/
│       ├── __init__.py
│       └── translator.py  # AWS Translate service
├── static/                # Frontend files
│   ├── index.html        # Main UI
│   ├── css/
│   │   └── styles.css    # Styling with dark mode
│   └── js/
│       └── app.js        # Frontend logic
├── Dockerfile            # Optimized multi-stage build
├── docker-compose.yml    # Local development setup
├── requirements.txt      # Python dependencies
├── .dockerignore        # Build optimization
└── .env.example         # Environment template
```

## Setup Instructions

### 1. Environment Configuration

Copy `.env.example` to `.env`:
```bash
cp .env.example .env
```

**Option A: Use AWS CLI Credentials (Recommended)**
- Docker will automatically use your AWS CLI credentials
- No need to set AWS_ACCESS_KEY_ID or AWS_SECRET_ACCESS_KEY

**Option B: Set Explicit Credentials**
Edit `.env` and add:
```
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
```

⚠️ **Important**: Never commit `.env` with real credentials! Add it to `.gitignore`

### 2. Local Development

Run with Docker Compose:
```bash
docker-compose up -d --build
```

Access the app at: http://localhost:8000

Test the API:
```bash
# Health check
curl http://localhost:8000/api/health

# Translate
curl -X POST http://localhost:8000/api/translate \
  -H "Content-Type: application/json" \
  -d '{"text": "cat", "target_language": "somali"}'
```

### 3. Production Build

Build optimized AMD64 image for AWS:
```bash
docker build --platform linux/amd64 -t dictionary-app .
```

## AWS Requirements

- **AWS Translate** access in your region (default: eu-west-2)
- **IAM permissions** for `translate:TranslateText`
- **Optional**: ECR for image storage, ECS/Fargate for deployment

## API Endpoints

- `GET /api/health` - Health check
- `POST /api/translate` - Translate text
- `GET /api/languages` - List supported languages
- `GET /` - Web UI

## Supported Languages

| Language | Code     | Flag |
|----------|----------|------|
| Somali   | somali   | 🇸🇴  |
| French   | french   | 🇫🇷  |
| Spanish  | spanish  | 🇪🇸  |
| Arabic   | arabic   | 🇸🇦  |

## Technology Stack

- **Backend**: FastAPI 0.104.1, Python 3.11
- **Translation**: AWS Translate via boto3
- **Frontend**: Vanilla JavaScript, Tailwind CSS
- **Deployment**: Docker, AWS ECS/Fargate

## Docker Image

- **Base**: python:3.11-slim
- **Size**: 163MB (optimized with multi-stage build)
- **Platform**: linux/amd64 (ECS compatible)
- **User**: Non-root for security

## Notes

- AWS Translate charges ~$15 per million characters
- Image is optimized for AWS ECS Fargate deployment
- Health checks run every 30 seconds
- All translations are from English to target language
