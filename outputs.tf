//output "invoke_arn" {
//  value = aws_api_gateway_deployment.deployment1.invoke_url
//}
//
//output "stage_name" {
//  value = aws_api_gateway_stage.stage.stage_name
//}
//
//output "path_part" {
//  value = aws_api_gateway_resource.hello_world.path_part
//}
//
//output "complete_unvoke_url" {
//  value = "${aws_api_gateway_deployment.deployment1.invoke_url}${aws_api_gateway_stage.stage.stage_name}/${aws_api_gateway_resource.hello_world.path_part}"
//}