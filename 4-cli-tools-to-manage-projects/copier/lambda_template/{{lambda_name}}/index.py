from loguru import logger
# import boto3
# import requests


def lambda_handler(event, context):
    logger.info('Starting lambda')
    response = {
        'statusCode': 200,
        'body': 'OK'
    }
    return response
