# Implantação da API
resource "aws_api_gateway_deployment" "eks_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.cliente_integration,
    aws_api_gateway_integration.pedido_integration,
    aws_api_gateway_integration.cozinha_fila_atual_integration,
    aws_api_gateway_integration.cozinha_produtos_get_integration,
    aws_api_gateway_integration.cozinha_produtos_post_integration,
    aws_api_gateway_integration.cozinha_produtos_put_integration,
    aws_api_gateway_integration.cozinha_produtos_delete_integration,
    aws_api_gateway_integration.cozinha_fila_preparacao_integration,
  ]
  
  rest_api_id = aws_api_gateway_rest_api.eks_api.id
  
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.cliente_resource.id,
      aws_api_gateway_method.cliente_method.id,
      aws_api_gateway_integration.cliente_integration.id,
      aws_api_gateway_resource.pedido_resource.id,
      aws_api_gateway_method.pedido_method.id,
      aws_api_gateway_integration.pedido_integration.id,
      aws_api_gateway_resource.cozinha_fila_atual_resource.id,
      aws_api_gateway_method.cozinha_fila_atual_method.id,
      aws_api_gateway_integration.cozinha_fila_atual_integration.id,
      aws_api_gateway_resource.cozinha_produtos_resource.id,
      aws_api_gateway_method.cozinha_produtos_get_method.id,
    aws_api_gateway_integration.cozinha_produtos_get_integration.id,
    aws_api_gateway_method.cozinha_produtos_post_method.id,
    aws_api_gateway_integration.cozinha_produtos_post_integration.id,
    aws_api_gateway_method.cozinha_produtos_put_method.id,
    aws_api_gateway_integration.cozinha_produtos_put_integration.id,
    aws_api_gateway_method.cozinha_produtos_delete_method.id,
    aws_api_gateway_integration.cozinha_produtos_delete_integration.id,
    aws_api_gateway_method.cozinha_fila_preparacao_method.id,
    aws_api_gateway_integration.cozinha_fila_preparacao_integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Estágio da API
resource "aws_api_gateway_stage" "eks_api_stage" {
  deployment_id = aws_api_gateway_deployment.eks_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.eks_api.id
  stage_name    = "hm"
}

# Outputs dos endpoints
output "api_cliente_endpoint" {
  value = "${aws_api_gateway_stage.eks_api_stage.invoke_url}/cliente"
}

output "api_pedido_endpoint" {
  value = "${aws_api_gateway_stage.eks_api_stage.invoke_url}/pedido"
}

output "api_cozinha_endpoint" {
  value = "${aws_api_gateway_stage.eks_api_stage.invoke_url}/cozinha"
}