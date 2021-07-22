resource "aws_iam_role" "crawler_role" {
  name = "AWSGlueServiceRole-crawler"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "crawler_role_policy_attachment" {
  role = aws_iam_role.crawler_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy" "crawler_role_policy" {
  name = "AWSGlueServiceRolePolicy-crawler"
  role = aws_iam_role.crawler_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "dynamodb:*",
        Resource = aws_dynamodb_table.dynamodb_table.arn
      }
    ]
  })
}

resource "aws_glue_catalog_database" "glue_catalog_customer_orders_database" {
  name = "customer_orders_database_catalog"
}

resource "aws_glue_crawler" "dynamodb_table_crawler" {
  database_name = aws_glue_catalog_database.glue_catalog_customer_orders_database.name
  name = "dynamodb_table_crawler"
  role = aws_iam_role.crawler_role.arn

  dynamodb_target {
    path = aws_dynamodb_table.dynamodb_table.name
    scan_all = true
    scan_rate = 0.1
  }
}
