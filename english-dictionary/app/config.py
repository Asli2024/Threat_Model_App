from pydantic_settings import BaseSettings
from typing import Optional
import os


class Settings(BaseSettings):
    """Application settings loaded from environment variables"""

    # AWS Configuration
    AWS_REGION: str = "eu-west-2"
    AWS_ACCESS_KEY_ID: Optional[str] = None
    AWS_SECRET_ACCESS_KEY: Optional[str] = None

    # DynamoDB Configuration
    DYNAMODB_TABLE_NAME: str = "dictionary_words"
    DYNAMODB_REGION: Optional[str] = None

    @property
    def dynamodb_region(self) -> str:
        """Get DynamoDB region, defaulting to AWS_REGION if not specified"""
        return self.DYNAMODB_REGION or self.AWS_REGION

    # Bedrock Model Configuration
    MODEL_ID: str = "anthropic.claude-3-7-sonnet-20250219-v1:0"
    BEDROCK_MAX_OUTPUT_LENGTH: int = 1000  # Renamed from MAX_TOKENS
    TEMPERATURE: float = 0.3
    TOP_P: float = 0.9

    # Backwards compatibility
    @property
    def MAX_TOKENS(self) -> int:
        return self.BEDROCK_MAX_OUTPUT_LENGTH

    # Application Configuration
    APP_NAME: str = "Somali Dictionary API"
    APP_VERSION: str = "1.0.0"
    DEBUG: bool = False

    class Config:
        env_file = ".env"
        case_sensitive = True


settings = Settings()
