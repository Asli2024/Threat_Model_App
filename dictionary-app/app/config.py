import os
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    """Application settings"""

    # Application Configuration
    app_name: str = "Multi-Language Dictionary"
    debug: bool = False

    # AWS Configuration
    aws_region: str = "eu-west-2"
    aws_access_key_id: str = ""
    aws_secret_access_key: str = ""

    class Config:
        env_file = ".env"
        case_sensitive = False

settings = Settings()
