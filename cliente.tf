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
  depends_on = [data.kubernetes_service.cliente_service]
  rest_api_id             = aws_api_gateway_rest_api.eks_api.id
  resource_id             = aws_api_gateway_resource.cliente_resource.id
  http_method             = aws_api_gateway_method.cliente_method.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.kubernetes_service.cliente_service.status.0.load_balancer.0.ingress.0.hostname}"
}