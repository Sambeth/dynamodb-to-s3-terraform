resource "aws_dynamodb_table" "dynamodb_table" {

  hash_key         = "order_id"
  range_key        = "payment_ts"
  name             = "Orders"
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = true
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
    enabled        = true
  }

  point_in_time_recovery {
    enabled = true
  }

#  depends_on = [
#    aws_lambda_function.stream_lambda_function
#  ]
}

resource "aws_dynamodb_table_item" "dynamodb_table_item" {
  table_name = aws_dynamodb_table.dynamodb_table.name
  hash_key   = aws_dynamodb_table.dynamodb_table.hash_key
  range_key  = aws_dynamodb_table.dynamodb_table.range_key
  for_each = {
    "1" = {
      payment_ts  = "2021-11-15 00:00:00"
      customer_id = "1"
      amount      = "100"
      product     = "soap"
      quantity    = "50"
    }
    "2" = {
      payment_ts  = "2021-11-16 00:00:00"
      customer_id = "1"
      amount      = "10"
      product     = "bread"
      quantity    = "2"
    }
    "3" = {
      payment_ts  = "2021-11-18 00:00:00"
      customer_id = "1"
      amount      = "15"
      product     = "sugar"
      quantity    = "10"
    }
    "4" = {
      payment_ts  = "2021-11-20 00:00:00"
      customer_id = "1"
      amount      = "20"
      product     = "cheese"
      quantity    = "1"
    }
    "5" = {
      payment_ts  = "2021-11-30 00:00:00"
      customer_id = "1"
      amount      = "150"
      product     = "potato"
      quantity    = "5"
    }
  }

  item = <<ITEM
{
  "order_id": {"S": "${each.key}"},
  "payment_ts": {"S": "${each.value.payment_ts}"},
  "customer_id": {"S": "${each.value.customer_id}"},
  "amount": {"S": "${each.value.amount}"},
  "product": {"S": "${each.value.product}"},
  "quantity": {"S": "${each.value.quantity}"}
}
ITEM
}
