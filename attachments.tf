#resource "aws_iam_role" "try_something" {
#  name = "simply_testing_something"
#  assume_role_policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [
#      {
#        Effect = "Allow"
#        Principal = {
#          Service = "states.amazonaws.com"
#        },
#        Action = "sts:AssumeRole"
#      }
#    ]
#  })
#}
#
#module "iam_role_inline_policy" {
#  source = "./iam_role_inline_policy"
#  name_prefix = "just_trying_out_something"
#  policy_document = data.aws_iam_policy_document.test_policy_document.json
#  role_id = aws_iam_role.try_something.id
#}

//resource "aws_iam_role_policy_attachment" "test_policy_attachment" {
//  policy_arn = module.policy.policy_arn
//  role = aws_iam_role.try_something.name
//}
//
//module "policy" {
//  source = "./policy"
//  name_prefix = "real_slim"
//  description = "Just for testing purposes"
//  policy_document = data.aws_iam_policy_document.test_policy_document.json
//}
//
#data "aws_iam_policy_document" "test_policy_document" {
#  statement {
#    sid = "1"
#
#    actions = [
#      "lambda:InvokeFunction"
#    ]
#
#    resources = ["*"]
#  }
#}
