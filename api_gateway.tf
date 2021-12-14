//resource "aws_api_gateway_rest_api" "hello_world_api_gateway" {
//  name = "hello-world-api-gateway"
//  endpoint_configuration {
//    types = ["REGIONAL"]
//  }
//}
//
//resource "aws_api_gateway_resource" "hello_world" {
//  parent_id = aws_api_gateway_rest_api.hello_world_api_gateway.root_resource_id
//  rest_api_id = aws_api_gateway_rest_api.hello_world_api_gateway.id
//  path_part = "hello"
//}
//
//resource "aws_api_gateway_method" "post" {
//  authorization = "NONE"
//  http_method = "POST"
//  resource_id = aws_api_gateway_resource.hello_world.id
//  rest_api_id = aws_api_gateway_rest_api.hello_world_api_gateway.id
//}
//
//resource "aws_api_gateway_integration" "integration" {
//  http_method = aws_api_gateway_method.post.http_method
//  resource_id = aws_api_gateway_resource.hello_world.id
//  rest_api_id = aws_api_gateway_rest_api.hello_world_api_gateway.id
//  type = "AWS_PROXY"
//  integration_http_method = "POST"
//  uri = aws_lambda_function.hello_world_function.invoke_arn
//}
//
//resource "aws_api_gateway_deployment" "deployment1" {
//  rest_api_id = aws_api_gateway_rest_api.hello_world_api_gateway.id
//
//  triggers = {
//    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.hello_world_api_gateway.body))
//  }
//
//  lifecycle {
//    create_before_destroy = true
//  }
//}
//
//resource "aws_api_gateway_stage" "stage" {
//  deployment_id = aws_api_gateway_deployment.deployment1.id
//  rest_api_id = aws_api_gateway_rest_api.hello_world_api_gateway.id
//  stage_name = "dev"
//}
