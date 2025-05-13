resource "aws_api_gateway_rest_api" "eks_api" {
  name        = "${var.NOME}-eks-api"
  description = "API Gateway para integração com serviços EKS existentes"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Recurso para serviço de cliente
resource "aws_api_gateway_resource" "cliente_resource" {
  rest_api_id = aws_api_gateway_rest_api.eks_api.id
  parent_id   = aws_api_gateway_rest_api.eks_api.root_resource_id
  path_part   = "cliente"
}

# Método HTTP para o serviço de cliente
resource "aws_api_gateway_method" "cliente_method" {
  rest_api_id   = aws_api_gateway_rest_api.eks_api.id
  resource_id   = aws_api_gateway_resource.cliente_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Integração usando o endereço do Load Balancer existente para cliente
resource "aws_api_gateway_integration" "cliente_integration" {
  rest_api_id             = aws_api_gateway_rest_api.eks_api.id
  resource_id             = aws_api_gateway_resource.cliente_resource.id
  http_method             = aws_api_gateway_method.cliente_method.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.kubernetes_service.cliente_service.status.0.load_balancer.0.ingress.0.hostname}"
}

# Recurso para serviço de pedido
resource "aws_api_gateway_resource" "pedido_resource" {
  rest_api_id = aws_api_gateway_rest_api.eks_api.id
  parent_id   = aws_api_gateway_rest_api.eks_api.root_resource_id
  path_part   = "pedido"
}

# Método HTTP para o serviço de pedido
resource "aws_api_gateway_method" "pedido_method" {
  rest_api_id   = aws_api_gateway_rest_api.eks_api.id
  resource_id   = aws_api_gateway_resource.pedido_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Integração usando o endereço do Load Balancer existente para pedido
resource "aws_api_gateway_integration" "pedido_integration" {
  rest_api_id             = aws_api_gateway_rest_api.eks_api.id
  resource_id             = aws_api_gateway_resource.pedido_resource.id
  http_method             = aws_api_gateway_method.pedido_method.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.kubernetes_service.pedido_service.status.0.load_balancer.0.ingress.0.hostname}"
}

# Recurso para serviço de cozinha
resource "aws_api_gateway_resource" "cozinha_resource" {
  rest_api_id = aws_api_gateway_rest_api.eks_api.id
  parent_id   = aws_api_gateway_rest_api.eks_api.root_resource_id
  path_part   = "cozinha"
}

# Método HTTP para o serviço de cozinha
resource "aws_api_gateway_method" "cozinha_method" {
  rest_api_id   = aws_api_gateway_rest_api.eks_api.id
  resource_id   = aws_api_gateway_resource.cozinha_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Integração usando o endereço do Load Balancer existente para cozinha
resource "aws_api_gateway_integration" "cozinha_integration" {
  rest_api_id             = aws_api_gateway_rest_api.eks_api.id
  resource_id             = aws_api_gateway_resource.cozinha_resource.id
  http_method             = aws_api_gateway_method.cozinha_method.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.kubernetes_service.cozinha_service.status.0.load_balancer.0.ingress.0.hostname}"
}

# Implantação da API
resource "aws_api_gateway_deployment" "eks_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.cliente_integration,
    aws_api_gateway_integration.pedido_integration,
    aws_api_gateway_integration.cozinha_integration
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
      aws_api_gateway_resource.cozinha_resource.id,
      aws_api_gateway_method.cozinha_method.id,
      aws_api_gateway_integration.cozinha_integration.id
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
  stage_name    = "prod"
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