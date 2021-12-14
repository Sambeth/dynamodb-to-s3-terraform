#resource "aws_iam_role" "athena_role" {
#  name = "athena-role"
#
#  assume_role_policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [
#      {
#        Action = "sts:AssumeRole"
#        Effect = "Allow"
#        Principal = {
#          Service = "athena.amazonaws.com"
#        }
#      },
#    ]
#  })
#}
#
#resource "aws_iam_role_policy" "athena_role_policy" {
#  name = "athena-role-policy"
#  role = aws_iam_role.athena_role.id
#  policy = jsonencode({
#    Version = "2012-10-17",
#    Statement = [
#      {
#        Effect = "Allow",
#        Action = "athena:*",
#        Resource = "*"
#      }
#    ]
#  })
#}
#
#resource "aws_glue_catalog_table" "aws_glue_catalog_table" {
#  name          = "customer_orders_s3_table"
#  database_name = aws_glue_catalog_database.glue_catalog_customer_orders_database.name
#
#  table_type = "EXTERNAL_TABLE"
#
#  parameters = {
#    EXTERNAL              = "TRUE"
#  }
#
#  storage_descriptor {
#    location      = "s3://${module.s3_bucket.s3_bucket_id}/data/"
#    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
#    output_format = "org.apache.hadoop.hive.ql.io.IgnoreKeyTextOutputFormat"
#
#    ser_de_info {
#      name                  = "jsonserde"
#      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
#
#      parameters = {
#        "serialization.format" = 1
#      }
#    }
#
#    columns {
#      name = "order_id"
#      type = "string"
#    }
#
#    columns {
#      name = "payment_ts"
#      type = "string"
#    }
#
#    columns {
#      name    = "amount"
#      type    = "string"
#      comment = ""
#    }
#
#    columns {
#      name    = "customer_id"
#      type    = "string"
#      comment = ""
#    }
#
#    columns {
#      name    = "product"
#      type    = "string"
#      comment = ""
#    }
#
#    columns {
#      name    = "quantity"
#      type    = "string"
#      comment = ""
#    }
#  }
#}
