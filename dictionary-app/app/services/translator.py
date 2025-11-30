import boto3
from botocore.exceptions import ClientError, BotoCoreError
import logging
from typing import Dict

logger = logging.getLogger(__name__)

class TranslatorService:
    """Service for translating text using AWS Translate"""

    SUPPORTED_LANGUAGES = {
        "somali": {"name": "Somali", "code": "so"},
        "french": {"name": "French", "code": "fr"},
        "spanish": {"name": "Spanish", "code": "es"},
        "arabic": {"name": "Arabic", "code": "ar"}
    }

    def __init__(self, aws_region: str = "eu-west-2"):
        """Initialize the translator service with AWS Translate"""
        self.aws_region = aws_region
        self.translate_client = boto3.client('translate', region_name=aws_region)
        logger.info(f"Initialized TranslatorService with AWS Translate (region: {aws_region})")

    def translate(self, text: str, target_language: str) -> Dict[str, any]:
        """
        Translate text to target language using AWS Translate

        Args:
            text: The text to translate
            target_language: Target language code (somali, french, spanish, arabic)

        Returns:
            Dictionary with translation result
        """
        if not text or not text.strip():
            return {
                "original": text,
                "translation": "",
                "target_language": target_language,
                "success": False,
                "error": "Text cannot be empty"
            }

        lang_info = self.SUPPORTED_LANGUAGES.get(target_language.lower())
        if not lang_info:
            return {
                "original": text,
                "translation": "",
                "target_language": target_language,
                "success": False,
                "error": f"Unsupported language: {target_language}"
            }

        try:
            logger.info(f"Translating '{text}' to {lang_info['name']} using AWS Translate")

            # Call AWS Translate
            response = self.translate_client.translate_text(
                Text=text,
                SourceLanguageCode='en',
                TargetLanguageCode=lang_info['code']
            )

            translation = response['TranslatedText']

            logger.info(f"Translation successful: {translation}")

            return {
                "original": text,
                "translation": translation,
                "target_language": lang_info['name'],
                "success": True
            }

        except (ClientError, BotoCoreError) as e:
            logger.error(f"AWS Translate error: {str(e)}", exc_info=True)

            return {
                "original": text,
                "translation": "",
                "target_language": lang_info['name'],
                "success": False,
                "error": f"AWS Translate error: {str(e)}"
            }
        except Exception as e:
            logger.error(f"Translation error: {str(e)}", exc_info=True)

            return {
                "original": text,
                "translation": "",
                "target_language": lang_info['name'],
                "success": False,
                "error": str(e)
            }
