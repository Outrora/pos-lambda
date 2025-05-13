resource "aws_api_gateway_rest_api" "usuario_api" {
  name        = "Usuario"
  description = "API Gateway para Lambda pegar usuario pelo CPF"
}

resource "aws_api_gateway_resource" "cliente_audit" {
  rest_api_id = aws_api_gateway_rest_api.usuario_api.id
  parent_id   = aws_api_gateway_rest_api.usuario_api.root_resource_id
  path_part   = "cliente_audit"
}

resource "aws_api_gateway_method" "cliente_audit" {
  rest_api_id   = aws_api_gateway_rest_api.usuario_api.id
  resource_id   = aws_api_gateway_resource.cliente_audit.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.usuario_api.id
  resource_id             = aws_api_gateway_resource.cliente_audit.id
  http_method             = aws_api_gateway_method.cliente_audit.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.usuario_api.invoke_arn
}

resource "aws_lambda_permission" "api_gateway_invoker" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.usuario_api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.usuario_api.execution_arn}/*/*"
}

