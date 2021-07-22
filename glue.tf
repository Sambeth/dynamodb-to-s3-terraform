//resource "aws_iam_role" "glue_job_role" {
//  name = "customer_orders_glue_job_role"
//  assume_role_policy = jsonencode({
//    Version = "2012-10-17",
//    Statement = [
//      {
//        Effect = "Allow"
//        Principal = {
//          Service = "glue.amazonaws.com"
//        },
//        Action = "sts:AssumeRole"
//      }
//    ]
//  })
//}
//
//resource "aws_iam_role_policy_attachment" "glue_job_role_policy_attachment" {
//  role = aws_iam_role.glue_job_role.name
//  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
//}
//
//resource "aws_iam_role_policy" "glue_job_role_policy" {
//  name = "customer_orders_glue_job_role_policy"
//  role = aws_iam_role.glue_job_role.id
//
//  policy = jsonencode({
//    Version = "2012-10-17"
//    Statement = [
//      {
//        Action = [
//          "s3:*",
//        ]
//        Effect   = "Allow"
//        Resource = [
//          "arn:aws:s3:::${module.s3_bucket.s3_bucket_id}",
//          "arn:aws:s3:::${module.s3_bucket.s3_bucket_id}/*"
//        ]
//      },
//      {
//        Action = [
//          "dynamodb:*",
//        ]
//        Effect   = "Allow"
//        Resource = aws_dynamodb_table.dynamodb_table.arn
//      },
//    ]
//  })
//}
//
//resource "aws_glue_job" "customer_orders_glue_job" {
//  name = "customer_orders_glue_job"
//  role_arn = aws_iam_role.glue_job_role.arn
//  max_capacity = 2
//  timeout = 60
//  glue_version = "2.0"
//
//  command {
//    script_location = "s3://${module.s3_bucket.s3_bucket_id}/glue/script/customer_orders_glue_job.py"
//    python_version = "3"
//  }
//
//  default_arguments = {
//    "--job-language" = "python"
//    "--ENV" = "env"
//    "--spark-event-logs-path" = "s3://${module.s3_bucket.s3_bucket_id}/glue/logs"
//    "--job-bookmark-option" = "job-bookmark-enable"
//    "--s3_bucket" = module.s3_bucket.s3_bucket_id
//    "--dynamodb_table" = aws_dynamodb_table.dynamodb_table.name
//    "--catalog_database" = aws_glue_catalog_database.glue_catalog_customer_orders_database.name
//    "--customer_orders_s3_table" = aws_glue_catalog_table.aws_glue_catalog_table.name
//  }
//
//  execution_property {
//    max_concurrent_runs = 5
//  }
//}
//
//resource "aws_glue_trigger" "glue_trigger" {
//  name = "customer_orders_glue_trigger"
//  type = "CONDITIONAL"
//  enabled = true
//
//  actions {
//    job_name = aws_glue_job.customer_orders_glue_job.name
//  }
//
//  predicate {
//    conditions {
//      crawler_name = aws_glue_crawler.dynamodb_table_crawler.name
//      crawl_state = "SUCCEEDED"
//    }
//  }
//}
