resource "aws_iam_policy" "partiql_lambda_policy" {
  name        = "lambda-partiql-policy"
  description = "A test policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:PartiQLSelect"
      ],
      "Resource": "${aws_dynamodb_table.dynamodb_table.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "partiql_lambda_policy_attachment" {
  role       = aws_iam_role.iam_role_for_partiql_lambda.name
  policy_arn = aws_iam_policy.partiql_lambda_policy.arn
}

resource "aws_iam_policy" "pitr_lambda_policy" {
  name        = "lambda-pitr-policy"
  description = "A test policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:DescribeContinuousBackups",
        "dynamodb:RestoreTableToPointInTime"
      ],
      "Resource": [
          "${aws_dynamodb_table.dynamodb_table.arn}"
      ]
    },
    {
      "Effect": "Deny",
      "Action": [
        "dynamodb:DeleteTable"
      ],
      "Resource": [
          "${aws_dynamodb_table.dynamodb_table.arn}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:Scan",
        "dynamodb:Query",
        "dynamodb:UpdateItem",
        "dynamodb:PutItem",
        "dynamodb:GetItem",
        "dynamodb:DeleteItem",
        "dynamodb:BatchWriteItem",
        "dynamodb:DeleteTable"
      ],
      "Resource": [
          "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "pitr_lambda_policy_attachment" {
  role       = aws_iam_role.iam_role_for_pitr_lambda.name
  policy_arn = aws_iam_policy.pitr_lambda_policy.arn
}

#resource "aws_iam_policy" "stream_lambda_policy" {
#  name        = "lambda-steam-policy"
#  description = "A test policy"
#
#  policy = <<EOF
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Effect": "Allow",
#      "Action": [
#        "logs:CreateLogGroup",
#        "logs:CreateLogStream",
#        "logs:PutLogEvents"
#      ],
#      "Resource": "*"
#    },
#    {
#      "Effect": "Allow",
#      "Action": [
#        "s3:*"
#      ],
#      "Resource": [
#        "${module.s3_bucket.s3_bucket_arn}",
#        "${module.s3_bucket.s3_bucket_arn}/*"
#      ]
#    },
#  {
#      "Effect": "Allow",
#      "Action": [
#        "dynamodb:*"
#      ],
#      "Resource": "${aws_dynamodb_table.dynamodb_table.stream_arn}"
#    }
#  ]
#}
#EOF
#}

#resource "aws_iam_role_policy_attachment" "stream_lambda_policy_attachment" {
#  role       = aws_iam_role.iam_role_for_stream_lambda.name
#  policy_arn = aws_iam_policy.stream_lambda_policy.arn
#}