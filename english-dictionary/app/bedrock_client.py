import boto3
import json
import logging
from typing import Optional
from botocore.exceptions import ClientError
from .config import settings
from .prompts import create_user_prompt, SOMALI_DICTIONARY_SYSTEM_PROMPT

logger = logging.getLogger(__name__)


class BedrockClient:
    """AWS Bedrock client for Claude Sonnet interactions, with DynamoDB caching"""

    def __init__(self):
        """Initialize Bedrock client and DynamoDB table"""
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

        try:
            # Use local region for DynamoDB (Global Table handles replication)
            self.dynamodb = boto3.resource(
                "dynamodb",
                region_name=settings.dynamodb_region,
                aws_access_key_id=settings.AWS_ACCESS_KEY_ID,
                aws_secret_access_key=settings.AWS_SECRET_ACCESS_KEY,
            )
            self.table = self.dynamodb.Table(settings.DYNAMODB_TABLE_NAME)
            logger.info(f"DynamoDB table initialized: {settings.DYNAMODB_TABLE_NAME} in region: {settings.dynamodb_region}")
        except Exception as e:
            logger.error(f"Failed to initialize DynamoDB: {str(e)}")
            raise

    async def translate(
        self,
        word: str,
        direction: str = "english-to-somali",
        context: str = ""
    ) -> str:
        """
        Translate a word using Claude via Bedrock, with DynamoDB caching.

        Args:
            word: The word or phrase to translate
            direction: Translation direction
            context: Optional context for disambiguation

        Returns:
            The translation response from Claude or DynamoDB cache
        """
        # 1. Try DynamoDB first (reads from local region)
        try:
            response = self.table.get_item(Key={"word": word})
            if "Item" in response and "meaning" in response["Item"]:
                logger.info(f"Found '{word}' in DynamoDB cache (region: {settings.dynamodb_region}).")
                return response["Item"]["meaning"]
        except ClientError as e:
            logger.error(f"DynamoDB get_item error: {e}")

        # 2. Not found, call Bedrock
        try:
            user_prompt = create_user_prompt(word, direction, context)
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

            response = self.client.invoke_model(
                modelId=settings.MODEL_ID,
                contentType="application/json",
                accept="application/json",
                body=json.dumps(request_body)
            )

            response_body = json.loads(response['body'].read())

            if 'content' in response_body and len(response_body['content']) > 0:
                translation = response_body['content'][0]['text']
                logger.info(f"Successfully received translation for: {word}")
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

        # 3. Save to DynamoDB (writes to local region, auto-replicates to other regions)
        try:
            self.table.put_item(Item={"word": word, "meaning": translation})
            logger.info(f"Saved '{word}' to DynamoDB (region: {settings.dynamodb_region}).")
        except ClientError as e:
            logger.error(f"DynamoDB put_item error: {e}")

        return translation
