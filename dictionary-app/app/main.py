from fastapi import FastAPI, HTTPException, Request
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse, JSONResponse
from pydantic import BaseModel, Field
from app.config import settings
from app.services.translator import TranslatorService
import os
import logging
from typing import Optional

# Configure logging
logging.basicConfig(
    level=logging.INFO if not settings.debug else logging.DEBUG,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Initialize FastAPI app
app = FastAPI(
    title=settings.app_name,
    description="Multi-language dictionary powered by AWS Translate",
    version="1.0.0",
    debug=settings.debug
)

# Initialize translator service
translator = TranslatorService(aws_region=settings.aws_region)

# Pydantic models
class TranslationRequest(BaseModel):
    text: str = Field(..., min_length=1, max_length=500, description="Text to translate")
    target_language: str = Field(..., description="Target language code")

    class Config:
        json_schema_extra = {
            "example": {
                "text": "hello",
                "target_language": "somali"
            }
        }

class TranslationResponse(BaseModel):
    original: str
    translation: str
    target_language: str
    success: bool
    error: Optional[str] = None

class LanguageInfo(BaseModel):
    code: str
    name: str
    flag: str

# Exception handler
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    logger.error(f"Unhandled exception: {exc}", exc_info=True)
    return JSONResponse(
        status_code=500,
        content={"detail": "Internal server error"}
    )

# API endpoints
@app.get("/api/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "service": settings.app_name,
        "translator": "AWS Translate"
    }

@app.post("/api/translate", response_model=TranslationResponse)
async def translate_text(request: TranslationRequest):
    """
    Translate English text to target language
    """
    logger.info(f"Translation request: {request.text} -> {request.target_language}")

    if request.target_language.lower() not in TranslatorService.SUPPORTED_LANGUAGES:
        raise HTTPException(
            status_code=400,
            detail=f"Unsupported language. Supported: {list(TranslatorService.SUPPORTED_LANGUAGES.keys())}"
        )

    result = translator.translate(request.text, request.target_language)

    if not result["success"]:
        logger.error(f"Translation failed: {result.get('error')}")
        raise HTTPException(
            status_code=500,
            detail=result.get("error", "Translation failed")
        )

    return result

@app.get("/api/languages")
async def get_supported_languages():
    """Get list of supported languages"""
    return {
        "languages": [
            {"code": "somali", "name": "Somali", "flag": "🇸🇴"},
            {"code": "french", "name": "French", "flag": "🇫🇷"},
            {"code": "spanish", "name": "Spanish", "flag": "🇪🇸"},
            {"code": "arabic", "name": "Arabic", "flag": "🇸🇦"}
        ]
    }

# Serve static files
static_path = os.path.join(os.path.dirname(__file__), "..", "static")
if os.path.exists(static_path):
    app.mount("/static", StaticFiles(directory=static_path), name="static")

    # Serve index.html for all non-API routes
    @app.get("/{full_path:path}")
    async def serve_spa(full_path: str):
        """Serve the single page application"""
        if full_path.startswith("api/"):
            raise HTTPException(status_code=404, detail="API endpoint not found")
        return FileResponse(os.path.join(static_path, "index.html"))
else:
    logger.warning(f"Static directory not found at {static_path}")

# Startup event
@app.on_event("startup")
async def startup_event():
    logger.info(f"Starting {settings.app_name}")
    logger.info(f"Using AWS Translate for translations (region: {settings.aws_region})")
