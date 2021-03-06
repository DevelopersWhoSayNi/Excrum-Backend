import traceback
import json
import boto3
import os
from boto3.dynamodb.conditions import Key, Attr


def lambda_handler(event, context):
    sprints_table_name = os.environ['SPRINTS_TABLE_NAME']
    sprints_table = boto3.resource('dynamodb').Table(sprints_table_name)
    try:
        if event['action'] == 'CreateNewSprint' or event['action'] == 'UpdateSprintDetails':
            sprints_id = sprints_table.put_item(Item={'id': event["sprintDetails"]["id"],
                                                      "capacityDetails": event["sprintDetails"]["capacityDetails"],
                                                      "startDate": event["sprintDetails"]["startDate"],
                                                      "endDate": event["sprintDetails"]["endDate"],
                                                      "iterationPath": event["sprintDetails"]["iterationPath"],
                                                      "lastSprintId": event["sprintDetails"]["lastSprintId"],
                                                      "sprintLength": event["sprintDetails"]["sprintLength"],
                                                      "sprintNumber": event["sprintDetails"]["sprintNumber"],
                                                      "team": event["sprintDetails"]["team"]
                                                      })
        elif event['action'] == 'DeleteSprint':
            sprints_id = 'X'
            print('TODO')
        elif event['action'] == 'GetTeamSprints':
            sprintsResult = sprints_table.scan(
                FilterExpression=Attr('team.teamID').eq(event['teamId']))
            return sprintsResult['Items']
        elif event['action'] == 'GetSprint':
            sprintResult = sprints_table.get_item(
                Key={
                    'id': event['sprintID'].upper()
                }
            )
            return sprintResult['Item']

        return {
            'statusCode': 200,
            'body': {"sprintId": str(sprints_id)}
        }
    except Exception as general_exception:
        print(general_exception)
        print(traceback.format_exc())
