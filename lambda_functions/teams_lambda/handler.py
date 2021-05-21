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
        if event["action"] == "getTeamData":
            if 'teamId' not in event or not event['teamId'] :
                teams = teams_table.scan()
                return teams["Items"]
            else:
                team = teams_table.scan(FilterExpression=Attr('id').eq(event['teamId']))
                return team["Items"][0]
        elif event["action"] == "updateLastSprint":
            response = teams_table.update_item(
                Key={
                    'id': event['teamId']
                },
                UpdateExpression="set lastSprintId=:a",
                ExpressionAttributeValues={
                    ':a': event['lastSprintId']
                }
            )
            return "Done"

    except Exception as general_exception:
        print(general_exception)
        print(traceback.format_exc())