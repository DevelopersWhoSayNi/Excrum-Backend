import traceback
import json
import boto3
import os
from boto3.dynamodb.conditions import Key, Attr

import json

def lambda_handler(event, context):
    teams_table_name = os.environ['TEAMS_TABLE_NAME']
    teams_table = boto3.resource('dynamodb').Table(teams_table_name)
    try:
        if 'id' not in event and event['id'] is not "null":
            return {
                'statusCode': 400,
                'body': json.dumps('id is mandatory!')
            }
        else:
            teams = teams_table.scan(FilterExpression=Attr('id').eq(event['id']))
            return teams["Items"][0]

    except Exception as general_exception:
        print(general_exception)
        print(traceback.format_exc())