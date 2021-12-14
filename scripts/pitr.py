from datetime import datetime
import logging
import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb = boto3.client('dynamodb')

"""
{
    'ContinuousBackupsDescription': 
        {
            'ContinuousBackupsStatus': 'ENABLED', 
            'PointInTimeRecoveryDescription': 
                {
                    'PointInTimeRecoveryStatus': 'ENABLED', 
                    'EarliestRestorableDateTime': datetime.datetime(2021, 12, 13, 16, 52, 19, tzinfo=tzlocal()), 
                    'LatestRestorableDateTime': datetime.datetime(2021, 12, 13, 19, 52, 7, 970000, tzinfo=tzlocal())}}, 
                    'ResponseMetadata': {
                                            'RequestId': 'M8D1QCIILBV0MR3TOC375RF14RVV4KQNSO5AEMVJF66Q9ASUAAJG', 
                                            'HTTPStatusCode': 200, 
                                            'HTTPHeaders': 
                                                {
                                                    'server': 'Server', 
                                                    'date': 'Mon, 13 Dec 2021 19:57:07 GMT', 
                                                    'content-type': 'application/x-amz-json-1.0', 
                                                    'content-length': '229', 
                                                    'connection': 'keep-alive', 
                                                    'x-amzn-requestid': 'M8D1QCIILBV0MR3TOC375RF14RVV4KQNSO5AEMVJF66Q9ASUAAJG', 
                                                    'x-amz-crc32': '2839589893'
                                                }, 
                                            'RetryAttempts': 0
                                        }
}
"""


def confirm_pitr_is_enabled(table_name):
    response = dynamodb.describe_continuous_backups(
        TableName=table_name
    )
    logger.info(response)
    enabled = response['ContinuousBackupsDescription']['PointInTimeRecoveryDescription']['PointInTimeRecoveryStatus']
    if enabled == 'ENABLED':
        earliest_date = response['ContinuousBackupsDescription']['PointInTimeRecoveryDescription']['EarliestRestorableDateTime']
        latest_date = response['ContinuousBackupsDescription']['PointInTimeRecoveryDescription']['LatestRestorableDateTime']
        return True, earliest_date, latest_date
    return False


def restore_table(table_name, target_table_name, point_in_time):
    response = dynamodb.restore_table_to_point_in_time(
        SourceTableName=table_name,
        TargetTableName=target_table_name,
        RestoreDateTime=point_in_time,
        UseLatestRestorableTime=False
    )
    return response


def delete_table(table_name):
    response = dynamodb.delete_table(
        TableName=table_name
    )
    return response


def handler(event, context):
    response = None
    date_string_format = '%Y-%m-%d'

    logger.info(event)
    if 'type' not in event:
        raise Exception("'type' is a required field in event")
    if 'table_name' not in event:
        raise Exception("'table_name' is a required field in event")
    if event.get('type') == 'delete':
        response = delete_table(event.get('table_name'))
        logger.info(response)
        return

    if 'target_table_name' not in event:
        raise Exception("'target_table_name' is a required field in event")
    if 'point_in_time' not in event:
        raise Exception("'point_in_time' is a required field in event and date must be in ISO format")

    table_name = event.get('table_name')
    target_table_name = event.get('target_table_name')
    point_in_time = event.get('point_in_time')

    enabled = confirm_pitr_is_enabled(table_name=table_name)

    if enabled[0]:
        if point_in_time == 'earliest':
            point_in_time = enabled[1]
        elif point_in_time == 'latest':
            point_in_time = enabled[2]
        else:
            try:
                point_in_time = datetime.strptime(date_string_format, point_in_time)
            except ValueError as e:
                raise ValueError("Kindly make sure the `point_in_time` value is in the format YYYY-MM-DD")
        logger.info(f"These are the values: {table_name} | {target_table_name} | {point_in_time}")
        response = restore_table(
            table_name=table_name,
            target_table_name=target_table_name,
            point_in_time=point_in_time
        )
    else:
        raise Exception(f"{table_name} table does not have Point In Time Recovery enabled.")
    logger.info(response)
