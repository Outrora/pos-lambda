# Implantação da API
resource "aws_api_gateway_deployment" "eks_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.eks_api.id
  
  triggers = {
    redeployment = timestamp()
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