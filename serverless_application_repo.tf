#data "aws_serverlessapplicationrepository_application" "athena_dynamodb_connector" {
#  application_id = "arn:aws:serverlessrepo:us-east-1:292517598671:applications/AthenaDynamoDBConnector"
#}
#
#resource "aws_serverlessapplicationrepository_cloudformation_stack" "athena_dynamodb_connector" {
#  name             = "dynamodb-connector"
#  application_id   = data.aws_serverlessapplicationrepository_application.athena_dynamodb_connector.application_id
#  semantic_version = data.aws_serverlessapplicationrepository_application.athena_dynamodb_connector.semantic_version
#  capabilities     = data.aws_serverlessapplicationrepository_application.athena_dynamodb_connector.required_capabilities
#  parameters = {
#    SpillBucket       = module.s3_bucket.s3_bucket_id
#    AthenaCatalogName = "dynamo"
#  }
#}

#data "aws_serverlessapplicationrepository_application" "hello_world" {
#  application_id = "arn:aws:serverlessrepo:us-east-1:077246666028:applications/hello-world"
#}
#
#resource "aws_serverlessapplicationrepository_cloudformation_stack" "athena_dynamodb_connector" {
#  name             = "dynamodb-connector"
#  application_id   = data.aws_serverlessapplicationrepository_application.hello_world.application_id
#  semantic_version = data.aws_serverlessapplicationrepository_application.hello_world.semantic_version
#  capabilities     = data.aws_serverlessapplicationrepository_application.hello_world.required_capabilities
#  parameters = {
#    IdentityNameParameter = "real"
#  }
#}
