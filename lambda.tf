data "archive_file" "lambda_script_zip" {
  source_dir  = "${path.module}/scripts/"
  output_path = "${path.module}/scripts.zip"
  type        = "zip"
}

resource "aws_lambda_function" "partiql_lambda_function" {
  function_name = "partiql-select"
  handler       = "partiql_select.handler"
  role          = aws_iam_role.iam_role_for_partiql_lambda.arn
  runtime       = "python3.8"
  timeout       = 900

  filename         = data.archive_file.lambda_script_zip.output_path
  source_code_hash = data.archive_file.lambda_script_zip.output_base64sha256
}

resource "aws_lambda_function" "pitr_lambda_function" {
  function_name = "pitr"
  handler       = "pitr.handler"
  role          = aws_iam_role.iam_role_for_pitr_lambda.arn
  runtime       = "python3.8"
  timeout       = 900

  filename         = data.archive_file.lambda_script_zip.output_path
  source_code_hash = data.archive_file.lambda_script_zip.output_base64sha256
}

#resource "aws_lambda_function" "stream_lambda_function" {
#  function_name = "stream-dynamodb"
#  handler       = "customer_orders.handler"
#  role          = aws_iam_role.iam_role_for_stream_lambda.arn
#  runtime       = "python3.8"
#  timeout       = 900
#  environment {
#    variables = {
#      S3_BUCKET = module.s3_bucket.s3_bucket_id
#    }
#  }
#
#  filename         = data.archive_file.lambda_script_zip.output_path
#  source_code_hash = data.archive_file.lambda_script_zip.output_base64sha256
#}

#resource "aws_lambda_event_source_mapping" "dynamodb_table_stream_lambda_event" {
#  function_name     = aws_lambda_function.stream_lambda_function.arn
#  event_source_arn  = aws_dynamodb_table.dynamodb_table.stream_arn
#  starting_position = "TRIM_HORIZON"
#}