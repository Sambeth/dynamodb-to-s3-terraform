import logging
import boto3
from boto3.dynamodb.types import TypeDeserializer

from tabulate import tabulate
import pandas as pd
pd.set_option('display.max_columns', None)
pd.set_option('display.max_rows', None)

deserializer = TypeDeserializer()

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def query_dynamodb_table(statement, limit, dynamodb=None):
    if not dynamodb:
        dynamodb = boto3.client('dynamodb')

    response = dynamodb.execute_statement(
        Statement=f'{statement}'
    )
    items = response['Items']
    deserialized_items = deserialize_response(items)
    print(items)
    print(deserialized_items)
    print('******DATAFRAME******')
    print(pd.DataFrame(deserialized_items).head(limit).to_string(index=False))
    df = pd.DataFrame(deserialized_items).head(limit)
    print(tabulate(df, headers='keys', tablefmt='psql'))
    return None


def deserialize_response(items):
    deserialized_document = list()

    for row in items:
        row_dict = dict()
        for k, v in row.items():
            row_dict[k] = deserializer.deserialize(v)
        deserialized_document.append(row_dict)

    return deserialized_document


def handler(event, context):
    logger.info(event)
    return query_dynamodb_table(statement=event['statement'], limit=event['limit'])
