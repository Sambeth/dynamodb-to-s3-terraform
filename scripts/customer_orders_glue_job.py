import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

import boto3

args = getResolvedOptions(sys.argv, ['JOB_NAME', 's3_bucket', 'dynamodb_table', 'catalog_database', 'customer_orders_s3_table'])

dynamodb_table_name = args['dynamodb_table']
catalog_database_name = args['catalog_database']
customer_orders_s3_table = args['customer_orders_s3_table']
destination_bucket = "s3://" + args['s3_bucket']
destination_folder = "data/"

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

datasource0 = glueContext.create_dynamic_frame.from_catalog(
    database=catalog_database_name,
    table_name=f"{dynamodb_table_name}".lower().replace('-', '_'),
    transformation_ctx="datasource0"
)

datasource0.printSchema()
datasource0.toDF().show(10)

applymapping1 = ApplyMapping.apply(
    frame=datasource0, mappings=[
        ("order_id", "string", "order_id", "string"),
        ("payment_ts", "string", "payment_ts", "string"),
        ("customer_id", "string", "customer_id", "string"),
        ("amount", "string", "amount", "string"),
        ("product", "string", "product", "string")
    ], transformation_ctx="applymapping1"
)

selectfields2 = SelectFields.apply(
    frame=applymapping1,
    paths=["order_id", "payment_ts", "customer_id", "amount", "product"],
    transformation_ctx="selectfields2"
)

resolvechoice3 = ResolveChoice.apply(
    frame=selectfields2,
    choice="MATCH_CATALOG",
    database=catalog_database_name,
    table_name=customer_orders_s3_table,
    transformation_ctx="resolvechoice3"
)

resolvechoice4 = ResolveChoice.apply(
    frame=resolvechoice3,
    choice="make_struct",
    transformation_ctx="resolvechoice4"
)

datasink5 = glueContext.write_dynamic_frame.from_catalog(
    frame=resolvechoice4,
    database=catalog_database_name,
    table_name=customer_orders_s3_table,
    transformation_ctx="datasink5"
)

job.commit()
