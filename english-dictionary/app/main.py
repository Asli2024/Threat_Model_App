from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from pydantic import BaseModel, Field
from typing import Optional
import logging
import os

from .bedrock_client import BedrockClient
from .config import settings

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Initialize FastAPI app
app = FastAPI(
    title="Somali Dictionary API",
    description="A Somali-English dictionary powered by AWS Bedrock and Claude",
    version="1.0.0"
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure appropriately for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize Bedrock client
bedrock_client = BedrockClient()

# Mount static files
static_dir = os.path.join(os.path.dirname(os.path.dirname(__file__)), "static")
if os.path.exists(static_dir):
    app.mount("/static", StaticFiles(directory=static_dir), name="static")


# Request/Response Models
class TranslationRequest(BaseModel):
    text: str = Field(..., min_length=1, max_length=200, description="Word or phrase to translate")
    source_lang: str = Field(..., description="Source language code (e.g., 'en', 'so')")
    target_lang: str = Field(..., description="Target language code (e.g., 'en', 'so')")
    context: Optional[str] = Field(default="", max_length=500, description="Optional context for disambiguation")

    class Config:
        json_schema_extra = {
            "example": {
                "text": "cousin",
                "source_lang": "en",
                "target_lang": "so",
                "context": ""
            }
        }


class TranslationResponse(BaseModel):
    word: str
    direction: str
    translation: str
    success: bool
    model_used: str


# Health check endpoint
@app.get("/api/health")
async def health_check():
    """Health check endpoint for ECS/load balancer"""
    return {
        "status": "healthy",
        "service": "somali-dictionary",
        "version": "1.0.0"
    }


# Root endpoint
@app.get("/")
async def root():
    """Serve the main dictionary web interface"""
    static_dir = os.path.join(os.path.dirname(os.path.dirname(__file__)), "static")
    index_file = os.path.join(static_dir, "index.html")
    if os.path.exists(index_file):
        return FileResponse(index_file)
    return {
        "message": "Somali Dictionary API",
        "version": "1.0.0",
        "endpoints": {
            "translate": "/api/translate",
            "health": "/api/health",
            "docs": "/docs"
        }
    }


# Translation endpoint
@app.post("/api/translate", response_model=TranslationResponse)
async def translate(request: TranslationRequest):
    """
    Translate a word or phrase between Somali and English

    Args:
        request: TranslationRequest containing text, source_lang, target_lang, and optional context

    Returns:
        TranslationResponse with the translation and metadata
    """
    try:
        # Map language codes to direction format
        if request.source_lang == "en" and request.target_lang == "so":
            direction = "english-to-somali"
        elif request.source_lang == "so" and request.target_lang == "en":
            direction = "somali-to-english"
        else:
            raise HTTPException(
                status_code=400,
                detail="Unsupported language pair. Supported pairs: en->so, so->en"
            )

        logger.info(f"Translation request: {request.text} ({direction})")

        # Get translation from Bedrock (bedrock_client expects 'word' parameter)
        translation = await bedrock_client.translate(
            word=request.text,
            direction=direction,
            context=request.context
        )

        logger.info(f"Translation successful for: {request.text}")

        return TranslationResponse(
            word=request.text,
            direction=direction,
            translation=translation,
            success=True,
            model_used=settings.MODEL_ID
        )

    except ValueError as e:
        logger.error(f"Validation error: {str(e)}")
        raise HTTPException(status_code=400, detail=str(e))

    except Exception as e:
        logger.error(f"Translation error: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail=f"Translation failed: {str(e)}"
        )


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "app.main:app",
        host="0.0.0.0",
        port=8000,
        reload=True
    )
