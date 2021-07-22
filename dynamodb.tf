resource "aws_dynamodb_table" "dynamodb_table" {

  hash_key = "order_id"
  range_key = "payment_ts"
  name = "Starter"
  billing_mode = "PAY_PER_REQUEST"
  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "order_id"
    type = "S"
  }

  attribute {
    name = "payment_ts"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled = true
  }
}
