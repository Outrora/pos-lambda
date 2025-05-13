resource "aws_api_gateway_rest_api" "lanchonete_api" {
  name        = "${var.NOME}-lanchonete-api"
  description = "API Gateway para acesso aos microserviços no EKS"
  
  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = {
    projeto = var.TAGS
  }
}

# Recursos para o serviço Cliente
resource "aws_api_gateway_resource" "cliente" {
  rest_api_id = aws_api_gateway_rest_api.lanchonete_api.id
  parent_id   = aws_api_gateway_rest_api.lanchonete_api.root_resource_id
  path_part   = "cliente"
}

# Recurso para o serviço Cozinha
resource "aws_api_gateway_resource" "cozinha" {
  rest_api_id = aws_api_gateway_rest_api.lanchonete_api.id
  parent_id   = aws_api_gateway_rest_api.lanchonete_api.root_resource_id
  path_part   = "cozinha"
}

# Recurso para o serviço Pedido
resource "aws_api_gateway_resource" "pedido" {
  rest_api_id = aws_api_gateway_rest_api.lanchonete_api.id
  parent_id   = aws_api_gateway_rest_api.lanchonete_api.root_resource_id
  path_part   = "pedido"
}

# Configuração para capturar qualquer caminho após /cliente/*
resource "aws_api_gateway_resource" "cliente_proxy" {
  rest_api_id = aws_api_gateway_rest_api.lanchonete_api.id
  parent_id   = aws_api_gateway_resource.cliente.id
  path_part   = "{proxy+}"
}

# Configuração para capturar qualquer caminho após /cozinha/*
resource "aws_api_gateway_resource" "cozinha_proxy" {
  rest_api_id = aws_api_gateway_rest_api.lanchonete_api.id
  parent_id   = aws_api_gateway_resource.cozinha.id
  path_part   = "{proxy+}"
}

# Configuração para capturar qualquer caminho após /pedido/*
resource "aws_api_gateway_resource" "pedido_proxy" {
  rest_api_id = aws_api_gateway_rest_api.lanchonete_api.id
  parent_id   = aws_api_gateway_resource.pedido.id
  path_part   = "{proxy+}"
}

# Configuração dos métodos HTTP para o cliente
resource "aws_api_gateway_method" "cliente_any" {
  rest_api_id   = aws_api_gateway_rest_api.lanchonete_api.id
  resource_id   = aws_api_gateway_resource.cliente.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "cliente_proxy_any" {
  rest_api_id   = aws_api_gateway_rest_api.lanchonete_api.id
  resource_id   = aws_api_gateway_resource.cliente_proxy.id
  http_method   = "ANY"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

# Configuração dos métodos HTTP para a cozinha
resource "aws_api_gateway_method" "cozinha_any" {
  rest_api_id   = aws_api_gateway_rest_api.lanchonete_api.id
  resource_id   = aws_api_gateway_resource.cozinha.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "cozinha_proxy_any" {
  rest_api_id   = aws_api_gateway_rest_api.lanchonete_api.id
  resource_id   = aws_api_gateway_resource.cozinha_proxy.id
  http_method   = "ANY"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

# Configuração dos métodos HTTP para pedido
resource "aws_api_gateway_method" "pedido_any" {
  rest_api_id   = aws_api_gateway_rest_api.lanchonete_api.id
  resource_id   = aws_api_gateway_resource.pedido.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "pedido_proxy_any" {
  rest_api_id   = aws_api_gateway_rest_api.lanchonete_api.id
  resource_id   = aws_api_gateway_resource.pedido_proxy.id
  http_method   = "ANY"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

# Obter a URL dos load balancers EKS - Podemos usar data sources para pegar dinamicamente
data "aws_lb" "eks_cliente" {
  name = "${var.NOME}-cliente-lb"
  depends_on = [aws_api_gateway_rest_api.lanchonete_api]
}

data "aws_lb" "eks_cozinha" {
  name = "${var.NOME}-cozinha-lb"
  depends_on = [aws_api_gateway_rest_api.lanchonete_api]
}

data "aws_lb" "eks_pedido" {
  name = "${var.NOME}-pedido-lb"
  depends_on = [aws_api_gateway_rest_api.lanchonete_api]
}

# Integrações para o serviço Cliente
resource "aws_api_gateway_integration" "cliente_integration" {
  rest_api_id             = aws_api_gateway_rest_api.lanchonete_api.id
  resource_id             = aws_api_gateway_resource.cliente.id
  http_method             = aws_api_gateway_method.cliente_any.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.aws_lb.eks_cliente.dns_name}"
  
  connection_type = "INTERNET"
}

resource "aws_api_gateway_integration" "cliente_proxy_integration" {
  rest_api_id             = aws_api_gateway_rest_api.lanchonete_api.id
  resource_id             = aws_api_gateway_resource.cliente_proxy.id
  http_method             = aws_api_gateway_method.cliente_proxy_any.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.aws_lb.eks_cliente.dns_name}/{proxy}"
  
  connection_type = "INTERNET"
  
  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

# Integrações para o serviço Cozinha
resource "aws_api_gateway_integration" "cozinha_integration" {
  rest_api_id             = aws_api_gateway_rest_api.lanchonete_api.id
  resource_id             = aws_api_gateway_resource.cozinha.id
  http_method             = aws_api_gateway_method.cozinha_any.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.aws_lb.eks_cozinha.dns_name}"
  
  connection_type = "INTERNET"
}

resource "aws_api_gateway_integration" "cozinha_proxy_integration" {
  rest_api_id             = aws_api_gateway_rest_api.lanchonete_api.id
  resource_id             = aws_api_gateway_resource.cozinha_proxy.id
  http_method             = aws_api_gateway_method.cozinha_proxy_any.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.aws_lb.eks_cozinha.dns_name}/{proxy}"
  
  connection_type = "INTERNET"
  
  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

# Integrações para o serviço Pedido
resource "aws_api_gateway_integration" "pedido_integration" {
  rest_api_id             = aws_api_gateway_rest_api.lanchonete_api.id
  resource_id             = aws_api_gateway_resource.pedido.id
  http_method             = aws_api_gateway_method.pedido_any.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.aws_lb.eks_pedido.dns_name}"
  
  connection_type = "INTERNET"
}

resource "aws_api_gateway_integration" "pedido_proxy_integration" {
  rest_api_id             = aws_api_gateway_rest_api.lanchonete_api.id
  resource_id             = aws_api_gateway_resource.pedido_proxy.id
  http_method             = aws_api_gateway_method.pedido_proxy_any.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.aws_lb.eks_pedido.dns_name}/{proxy}"
  
  connection_type = "INTERNET"
  
  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

# Deployment da API
resource "aws_api_gateway_deployment" "lanchonete_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.lanchonete_api.id
  
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.cliente.id,
      aws_api_gateway_resource.cliente_proxy.id,
      aws_api_gateway_resource.cozinha.id,
      aws_api_gateway_resource.cozinha_proxy.id,
      aws_api_gateway_resource.pedido.id,
      aws_api_gateway_resource.pedido_proxy.id,
      aws_api_gateway_method.cliente_any.id,
      aws_api_gateway_method.cliente_proxy_any.id,
      aws_api_gateway_method.cozinha_any.id,
      aws_api_gateway_method.cozinha_proxy_any.id,
      aws_api_gateway_method.pedido_any.id,
      aws_api_gateway_method.pedido_proxy_any.id,
      aws_api_gateway_integration.cliente_integration.id,
      aws_api_gateway_integration.cliente_proxy_integration.id,
      aws_api_gateway_integration.cozinha_integration.id,
      aws_api_gateway_integration.cozinha_proxy_integration.id,
      aws_api_gateway_integration.pedido_integration.id,
      aws_api_gateway_integration.pedido_proxy_integration.id
    ]))
  }
  
  lifecycle {
    create_before_destroy = true
  }
}

# Estágio da API
resource "aws_api_gateway_stage" "lanchonete_api_stage" {
  deployment_id = aws_api_gateway_deployment.lanchonete_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.lanchonete_api.id
  stage_name    = "prod"
}

# Output da URL da API Gateway
output "api_gateway_url_eks" {
  value = "${aws_api_gateway_deployment.lanchonete_api_deployment.invoke_url}${aws_api_gateway_stage.lanchonete_api_stage.stage_name}"
}