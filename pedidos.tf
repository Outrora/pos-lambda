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
  http_method   = "POST"
  authorization = "NONE"
}

# Integração usando o endereço do Load Balancer existente para pedido
resource "aws_api_gateway_integration" "pedido_integration" {
   depends_on = [data.kubernetes_service.pedido_service]
  rest_api_id             = aws_api_gateway_rest_api.eks_api.id
  resource_id             = aws_api_gateway_resource.pedido_resource.id
  http_method             = aws_api_gateway_method.pedido_method.http_method
  integration_http_method = "POST"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.kubernetes_service.pedido_service.status.0.load_balancer.0.ingress.0.hostname}/pedido"
}


# Recurso para serviço de pedido
resource "aws_api_gateway_resource" "pedido_resource_todos" {
  rest_api_id = aws_api_gateway_rest_api.eks_api.id
  parent_id   = aws_api_gateway_resource.pedido_resource.id
  path_part   = "todos"
}


# Método HTTP para o serviço de pedido
resource "aws_api_gateway_method" "pedido_method_todos" {
  rest_api_id   = aws_api_gateway_rest_api.eks_api.id
  resource_id   = aws_api_gateway_resource.pedido_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# Integração usando o endereço do Load Balancer existente para pedido
resource "aws_api_gateway_integration" "pedido_integration_todos" {
   depends_on = [data.kubernetes_service.pedido_service]
  rest_api_id             = aws_api_gateway_rest_api.eks_api.id
  resource_id             = aws_api_gateway_resource.pedido_resource.id
  http_method             = aws_api_gateway_method.pedido_method.http_method
  integration_http_method = "GET"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.kubernetes_service.pedido_service.status.0.load_balancer.0.ingress.0.hostname}/pedido/todos"
}


# Recurso para serviço de pedido
resource "aws_api_gateway_resource" "pedido_resource_id" {
  rest_api_id = aws_api_gateway_rest_api.eks_api.id
  parent_id   = aws_api_gateway_resource.pedido_resource.id
  path_part   = "{id}"
}


# Método HTTP para o serviço de pedido
resource "aws_api_gateway_method" "pedido_method_put" {
  rest_api_id   = aws_api_gateway_rest_api.eks_api.id
  resource_id   = aws_api_gateway_resource.pedido_resource.id
  http_method   = "PUT"
  authorization = "NONE"

   request_parameters = {
    "method.request.path.id" = true
  }
}

# Integração usando o endereço do Load Balancer existente para pedido
resource "aws_api_gateway_integration" "pedido_integration_put" {
   depends_on = [data.kubernetes_service.pedido_service]
  rest_api_id             = aws_api_gateway_rest_api.eks_api.id
  resource_id             = aws_api_gateway_resource.pedido_resource.id
  http_method             = aws_api_gateway_method.pedido_method.http_method
  integration_http_method = "PUT"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.kubernetes_service.pedido_service.status.0.load_balancer.0.ingress.0.hostname}/pedido/alterarEstado/{id}"

  request_parameters = {
    "integration.request.path.id" = "method.request.path.id"
  }
}


# Pagamento do pedido


# Recurso para serviço de pagamento
resource "aws_api_gateway_resource" "pagamento_resource" {
  rest_api_id = aws_api_gateway_rest_api.eks_api.id
  parent_id   = aws_api_gateway_rest_api.eks_api.root_resource_id
  path_part   = "pagamento"
}

resource "aws_api_gateway_resource" "pagamento_resource_id" {
  rest_api_id = aws_api_gateway_rest_api.eks_api.id
  parent_id   = aws_api_gateway_resource.pagamento_resource.id
  path_part   = "{id}"
}


# Método HTTP para o serviço de pagamento
resource "aws_api_gateway_method" "pagamento_method" {
  rest_api_id   = aws_api_gateway_rest_api.eks_api.id
  resource_id   = aws_api_gateway_resource.pagamento_resource_id.id
  http_method   = "POST"
  authorization = "NONE"
   request_parameters = {
    "method.request.path.id" = true
  }
}

# Integração usando o endereço do Load Balancer existente para pagamento
resource "aws_api_gateway_integration" "pagamento_integration" {
   depends_on = [data.kubernetes_service.pedido_service]
  rest_api_id             = aws_api_gateway_rest_api.eks_api.id
  resource_id             = aws_api_gateway_resource.pagamento_resource_id.id
  http_method             = aws_api_gateway_method.pagamento_method.http_method
  integration_http_method = "POST"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.kubernetes_service.pedido_service.status.0.load_balancer.0.ingress.0.hostname}/pedido/{id}"

   request_parameters = {
    "integration.request.path.id" = "method.request.path.id"
  }

}

# Método HTTP para o serviço de pagamento
resource "aws_api_gateway_method" "pagamento_method_put" {
  rest_api_id   = aws_api_gateway_rest_api.eks_api.id
  resource_id   = aws_api_gateway_resource.pagamento_resource_id.id
  http_method   = "PUT"
  authorization = "NONE"
   request_parameters = {
    "method.request.path.id" = true
  }
}

# Integração usando o endereço do Load Balancer existente para pagamento
resource "aws_api_gateway_integration" "pagamento_integration_put" {
   depends_on = [data.kubernetes_service.pedido_service]
  rest_api_id             = aws_api_gateway_rest_api.eks_api.id
  resource_id             = aws_api_gateway_resource.pagamento_resource_id.id
  http_method             = aws_api_gateway_method.pagamento_method.http_method
  integration_http_method = "PUT"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.kubernetes_service.pedido_service.status.0.load_balancer.0.ingress.0.hostname}/pedido/{id}"

   request_parameters = {
    "integration.request.path.id" = "method.request.path.id"
  }

}
