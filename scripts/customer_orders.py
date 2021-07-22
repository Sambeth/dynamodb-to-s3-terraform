import os
import json
import boto3


def handler(event, context):
    s3 = boto3.resource("s3")
    key = "data/metrics/sample.json"

    print("-------printing events--------")
    print(event)
    try:
        for record in event['Records']:
            if record['eventName'] == 'INSERT':
                print("-----INSERT-------")

                s3.Object(os.environ['S3_BUCKET'], key).put(
                    Body=json.dumps(record, indent=2)
                )
                print("DONE")

            elif record['eventName'] == 'MODIFY':
                print("-----UPDATE-------")

                s3.Object(os.environ['S3_BUCKET'], key).put(
                    Body=json.dumps(record, indent=2)
                )
                print("DONE")

    except Exception as e:
        print(e)
