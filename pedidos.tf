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
   depends_on = [data.kubernetes_service.pedido_service]
  rest_api_id             = aws_api_gateway_rest_api.eks_api.id
  resource_id             = aws_api_gateway_resource.pedido_resource.id
  http_method             = aws_api_gateway_method.pedido_method.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.kubernetes_service.pedido_service.status.0.load_balancer.0.ingress.0.hostname}"
}