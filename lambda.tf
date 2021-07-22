data "archive_file" "lambda_script_zip" {
  source_dir = "${path.module}/scripts/"
  output_path = "${path.module}/scripts.zip"
  type = "zip"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_stream_policy" {
  name = "lambda_stream_policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "dynamodb:DescribeStream",
        "dynamodb:GetRecords",
        "dynamodb:GetShardIterator",
        "dynamodb:ListStreams"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_steam_policy_attachment" {
  role = aws_iam_role.iam_for_lambda.id
  policy_arn = aws_iam_policy.lambda_stream_policy.arn
}

resource "aws_lambda_function" "orders_lambda_function" {
  function_name = "customer-orders-stream-function"
  handler = "customer_orders.handler"
  role = aws_iam_role.iam_for_lambda.arn
  runtime = "python3.8"

  environment {
    variables = {
      S3_BUCKET = module.s3_bucket.s3_bucket_id
    }
  }

  filename = data.archive_file.lambda_script_zip.output_path
  source_code_hash = data.archive_file.lambda_script_zip.output_base64sha256
}

resource "aws_lambda_event_source_mapping" "lambda_event_stream" {
  event_source_arn = aws_dynamodb_table.dynamodb_table.stream_arn
  function_name = aws_lambda_function.orders_lambda_function.arn
  starting_position = "LATEST"
}
