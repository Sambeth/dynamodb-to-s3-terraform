//resource "aws_iam_role" "athena_role" {
//  name = "athena-role"
//
//  assume_role_policy = jsonencode({
//    Version = "2012-10-17"
//    Statement = [
//      {
//        Action = "sts:AssumeRole"
//        Effect = "Allow"
//        Principal = {
//          Service = "athena.amazonaws.com"
//        }
//      },
//    ]
//  })
//}
//
//resource "aws_iam_role_policy" "athena_role_policy" {
//  name = "athena-role-policy"
//  role = aws_iam_role.athena_role.id
//  policy = jsonencode({
//    Version = "2012-10-17",
//    Statement = [
//      {
//        Effect = "Allow",
//        Action = "athena:*",
//        Resource = "*"
//      }
//    ]
//  })
//}
//
//resource "aws_athena_database" "customer_data_athena_database" {
//  name = "customer_data"
//  bucket = module.s3_bucket.s3_bucket_id
//  force_destroy = true
//}

resource "aws_glue_catalog_table" "aws_glue_catalog_table" {
  name          = "customer_orders_s3_table"
  database_name = aws_glue_catalog_database.glue_catalog_customer_orders_database.name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL              = "TRUE"
    "parquet.compression" = "SNAPPY"
  }

  storage_descriptor {
    location      = "s3://${module.s3_bucket.s3_bucket_id}/data-stream/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name                  = "data-stream"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"

      parameters = {
        "serialization.format" = 1
      }
    }

    columns {
      name = "order_id"
      type = "string"
    }

    columns {
      name = "payment_ts"
      type = "string"
    }

    columns {
      name    = "amount"
      type    = "string"
      comment = ""
    }

    columns {
      name    = "customer_id"
      type    = "string"
      comment = ""
    }

    columns {
      name    = "product"
      type    = "string"
      comment = ""
    }
  }
}
