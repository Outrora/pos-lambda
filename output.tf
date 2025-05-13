
#output "api_gateway_url" {
#  value = "https://${aws_api_gateway_rest_api.usuario_api.id}.execute-api.${var.regionDefault}.amazonaws.com/${aws_api_gateway_stage.hm.stage_name}"
#}