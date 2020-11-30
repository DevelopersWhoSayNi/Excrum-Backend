import traceback
import json
import boto3
import os
from boto3.dynamodb.conditions import Key, Attr

def lambda_handler(event, context):
    member_table_name = os.environ['MEMBER_TABLE_NAME']
    members_table = boto3.resource('dynamodb').Table(member_table_name)
    try:
        if 'id' not in event:
            return {
                'statusCode': 400,
                'body': 'Id is mandatory!'
            }
        else:
            member = members_table.scan(FilterExpression=Attr('id').eq(event['id']))
            return member["Items"][0]
            
    except Exception as general_exception:
        print(general_exception)
        print(traceback.format_exc())