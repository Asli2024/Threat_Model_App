import boto3
import json
import logging
from typing import Optional
from .config import settings
from .prompts import create_user_prompt, SOMALI_DICTIONARY_SYSTEM_PROMPT

logger = logging.getLogger(__name__)


class BedrockClient:
    """AWS Bedrock client for Claude Sonnet interactions"""

    def __init__(self):
        """Initialize Bedrock client with AWS credentials"""
        try:
            self.client = boto3.client(
                service_name='bedrock-runtime',
                region_name=settings.AWS_REGION,
                aws_access_key_id=settings.AWS_ACCESS_KEY_ID,
                aws_secret_access_key=settings.AWS_SECRET_ACCESS_KEY
            )
            logger.info(f"Bedrock client initialized for region: {settings.AWS_REGION}")
        except Exception as e:
            logger.error(f"Failed to initialize Bedrock client: {str(e)}")
            raise

    async def translate(
        self,
        word: str,
        direction: str = "english-to-somali",
        context: str = ""
    ) -> str:
        """
        Translate a word using Claude via Bedrock

        Args:
            word: The word or phrase to translate
            direction: Translation direction
            context: Optional context for disambiguation

        Returns:
            The translation response from Claude
        """
        try:
            # Create the user prompt
            user_prompt = create_user_prompt(word, direction, context)

            # Prepare the request body
            request_body = {
                "anthropic_version": "bedrock-2023-05-31",
                "max_tokens": settings.MAX_TOKENS,
                "temperature": settings.TEMPERATURE,
                "top_p": settings.TOP_P,
                "system": SOMALI_DICTIONARY_SYSTEM_PROMPT,
                "messages": [
                    {
                        "role": "user",
                        "content": user_prompt
                    }
                ]
            }

            logger.info(f"Sending request to Bedrock for word: {word}")

            # Invoke the model
            response = self.client.invoke_model(
                modelId=settings.MODEL_ID,
                contentType="application/json",
                accept="application/json",
                body=json.dumps(request_body)
            )

            # Parse the response
            response_body = json.loads(response['body'].read())

            # Extract the text from Claude's response
            if 'content' in response_body and len(response_body['content']) > 0:
                translation = response_body['content'][0]['text']
                logger.info(f"Successfully received translation for: {word}")
                return translation
            else:
                logger.error("Unexpected response structure from Bedrock")
                raise ValueError("Invalid response from Bedrock")

        except self.client.exceptions.ValidationException as e:
            logger.error(f"Validation error: {str(e)}")
            raise ValueError(f"Invalid request parameters: {str(e)}")

        except self.client.exceptions.ThrottlingException as e:
            logger.error(f"Throttling error: {str(e)}")
            raise Exception("Service is busy, please try again later")

        except Exception as e:
            logger.error(f"Bedrock invocation error: {str(e)}")
            raise Exception(f"Failed to get translation: {str(e)}")
