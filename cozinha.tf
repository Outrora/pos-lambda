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
  depends_on = [data.kubernetes_service.cozinha_service]
  rest_api_id             = aws_api_gateway_rest_api.eks_api.id
  resource_id             = aws_api_gateway_resource.cozinha_resource.id
  http_method             = aws_api_gateway_method.cozinha_method.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.kubernetes_service.cozinha_service.status.0.load_balancer.0.ingress.0.hostname}"
}


# Recurso para /cozinha/fila
resource "aws_api_gateway_resource" "cozinha_fila_resource" {
  rest_api_id = aws_api_gateway_rest_api.eks_api.id
  parent_id   = aws_api_gateway_resource.cozinha_resource.id
  path_part   = "fila"
}

# Recurso para /cozinha/fila/atual
resource "aws_api_gateway_resource" "cozinha_fila_atual_resource" {
  rest_api_id = aws_api_gateway_rest_api.eks_api.id
  parent_id   = aws_api_gateway_resource.cozinha_fila_resource.id
  path_part   = "atual"
}

# Método ANY para /cozinha/fila/atual
resource "aws_api_gateway_method" "cozinha_fila_atual_method" {
  rest_api_id   = aws_api_gateway_rest_api.eks_api.id
  resource_id   = aws_api_gateway_resource.cozinha_fila_atual_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Integração do método com o serviço Kubernetes para /cozinha/fila/atual
resource "aws_api_gateway_integration" "cozinha_fila_atual_integration" {
  depends_on = [data.kubernetes_service.cozinha_service]
  rest_api_id             = aws_api_gateway_rest_api.eks_api.id
  resource_id             = aws_api_gateway_resource.cozinha_fila_atual_resource.id
  http_method             = aws_api_gateway_method.cozinha_fila_atual_method.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.kubernetes_service.cozinha_service.status.0.load_balancer.0.ingress.0.hostname}/fila/atual"
}