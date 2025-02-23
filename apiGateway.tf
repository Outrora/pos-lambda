resource "aws_api_gateway_rest_api" "usuario_api" {
  name        = "Usuario"
  description = "API Gateway para Lambda pegar usuario pelo CPF"
}

resource "aws_api_gateway_resource" "cliente" {
  rest_api_id = aws_api_gateway_rest_api.usuario_api.id
  parent_id   = aws_api_gateway_rest_api.usuario_api.root_resource_id
  path_part   = "cliente"
}

resource "aws_api_gateway_method" "get_example" {
  rest_api_id   = aws_api_gateway_rest_api.usuario_api.id
  resource_id   = aws_api_gateway_resource.cliente.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.usuario_api.id
  resource_id = aws_api_gateway_resource.cliente.id
  http_method = aws_api_gateway_method.get_example.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.usuario_api.invoke_arn
}

resource "aws_lambda_permission" "api_gateway_invoker" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.usuario_api.function_name
  principal = "apigateway.amazonaws.com"
  
  # Permitir qualquer API Gateway chamar essa Lambda
  source_arn = "${aws_api_gateway_rest_api.usuario_api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.usuario_api.id
  triggers = {
       redeployment = sha1(jsonencode(aws_api_gateway_rest_api.usuario_api))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "hm" {
  stage_name    = "hm"
  rest_api_id   = aws_api_gateway_rest_api.usuario_api.id
  deployment_id = aws_api_gateway_deployment.api_deployment.id
}
