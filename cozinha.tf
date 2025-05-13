# Recurso para serviço de cozinha
resource "aws_api_gateway_resource" "cozinha_resource" {
  rest_api_id = aws_api_gateway_rest_api.eks_api.id
  parent_id   = aws_api_gateway_rest_api.eks_api.root_resource_id
  path_part   = "cozinha"
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

# Método GET para /cozinha/fila/atual
resource "aws_api_gateway_method" "cozinha_fila_atual_method" {
  rest_api_id   = aws_api_gateway_rest_api.eks_api.id
  resource_id   = aws_api_gateway_resource.cozinha_fila_atual_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# Integração do método com o serviço Kubernetes para /cozinha/fila/atual
resource "aws_api_gateway_integration" "cozinha_fila_atual_integration" {
  depends_on = [data.kubernetes_service.cozinha_service]
  rest_api_id             = aws_api_gateway_rest_api.eks_api.id
  resource_id             = aws_api_gateway_resource.cozinha_fila_atual_resource.id
  http_method             = aws_api_gateway_method.cozinha_fila_atual_method.http_method
  integration_http_method = "GET"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.kubernetes_service.cozinha_service.status.0.load_balancer.0.ingress.0.hostname}/fila/atual"
}


# Recurso para /cozinha/fila/preparacao
resource "aws_api_gateway_resource" "cozinha_fila_preparacao_resource" {
  rest_api_id = aws_api_gateway_rest_api.eks_api.id
  parent_id   = aws_api_gateway_resource.cozinha_fila_resource.id
  path_part   = "preparacao"
}

# Método GET para /cozinha/fila/preparacao
resource "aws_api_gateway_method" "cozinha_fila_preparacao_method" {
  rest_api_id   = aws_api_gateway_rest_api.eks_api.id
  resource_id   = aws_api_gateway_resource.cozinha_fila_preparacao_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# Integração do método com o serviço Kubernetes para /cozinha/fila/preparacao
resource "aws_api_gateway_integration" "cozinha_fila_preparacao_integration" {
  depends_on = [data.kubernetes_service.cozinha_service]
  rest_api_id             = aws_api_gateway_rest_api.eks_api.id
  resource_id             = aws_api_gateway_resource.cozinha_fila_preparacao_resource.id
  http_method             = aws_api_gateway_method.cozinha_fila_preparacao_method.http_method
  integration_http_method = "GET"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.kubernetes_service.cozinha_service.status.0.load_balancer.0.ingress.0.hostname}/fila/preparacao"
}



# _______________________ Produtos _______________________

# Recurso para /cozinha/produtos (já existe)
resource "aws_api_gateway_resource" "cozinha_produtos_resource" {
  rest_api_id = aws_api_gateway_rest_api.eks_api.id
  parent_id   = aws_api_gateway_resource.cozinha_resource.id
  path_part   = "produtos"
}

# /cozinha/produtos/{id}
resource "aws_api_gateway_resource" "cozinha_produtos_id_resource" {
  rest_api_id = aws_api_gateway_rest_api.eks_api.id
  parent_id   = aws_api_gateway_resource.cozinha_produtos_resource.id
  path_part   = "{id}"
}

# GET
resource "aws_api_gateway_method" "cozinha_produtos_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.eks_api.id
  resource_id   = aws_api_gateway_resource.cozinha_produtos_id_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "cozinha_produtos_get_integration" {
  depends_on = [data.kubernetes_service.cozinha_service]
  rest_api_id             = aws_api_gateway_rest_api.eks_api.id
  resource_id             = aws_api_gateway_resource.cozinha_produtos_id_resource.id
  http_method             = aws_api_gateway_method.cozinha_produtos_get_method.http_method
  integration_http_method = "GET"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.kubernetes_service.cozinha_service.status.0.load_balancer.0.ingress.0.hostname}/produtos/{id}"
}

# POST
resource "aws_api_gateway_method" "cozinha_produtos_post_method" {
  rest_api_id   = aws_api_gateway_rest_api.eks_api.id
  resource_id   = aws_api_gateway_resource.cozinha_produtos_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "cozinha_produtos_post_integration" {
  depends_on = [data.kubernetes_service.cozinha_service]
  rest_api_id             = aws_api_gateway_rest_api.eks_api.id
  resource_id             = aws_api_gateway_resource.cozinha_produtos_resource.id
  http_method             = aws_api_gateway_method.cozinha_produtos_post_method.http_method
  integration_http_method = "POST"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.kubernetes_service.cozinha_service.status.0.load_balancer.0.ingress.0.hostname}/produtos"
}

# PUT
resource "aws_api_gateway_method" "cozinha_produtos_put_method" {
  rest_api_id   = aws_api_gateway_rest_api.eks_api.id
  resource_id   = aws_api_gateway_resource.cozinha_produtos_id_resource.id
  http_method   = "PUT"
  authorization = "NONE"

}

resource "aws_api_gateway_integration" "cozinha_produtos_put_integration" {
  depends_on = [data.kubernetes_service.cozinha_service]
  rest_api_id             = aws_api_gateway_rest_api.eks_api.id
  resource_id             = aws_api_gateway_resource.cozinha_produtos_id_resource.id
  http_method             = aws_api_gateway_method.cozinha_produtos_put_method.http_method
  integration_http_method = "PUT"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.kubernetes_service.cozinha_service.status.0.load_balancer.0.ingress.0.hostname}/produtos/{id}"
}

# DELETE
resource "aws_api_gateway_method" "cozinha_produtos_delete_method" {
  rest_api_id   = aws_api_gateway_rest_api.eks_api.id
  resource_id   = aws_api_gateway_resource.cozinha_produtos_id_resource.id
  http_method   = "DELETE"
  authorization = "NONE"
  
}

resource "aws_api_gateway_integration" "cozinha_produtos_delete_integration" {
  depends_on = [data.kubernetes_service.cozinha_service]
  rest_api_id             = aws_api_gateway_rest_api.eks_api.id
  resource_id             = aws_api_gateway_resource.cozinha_produtos_id_resource.id
  http_method             = aws_api_gateway_method.cozinha_produtos_delete_method.http_method
  integration_http_method = "DELETE"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.kubernetes_service.cozinha_service.status.0.load_balancer.0.ingress.0.hostname}/produtos/{id}"
}
