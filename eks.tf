/* 
 * API Gateway to EKS Integration
 * This Terraform configuration creates an API Gateway that routes requests
 * to microservices running in an EKS cluster.
 */

# Fetch the EKS Load Balancer information
data "aws_lb" "eks_lb" {
  # Use a tag filter to find the load balancer created by the Kubernetes ingress controller
  tags = {
    "kubernetes.io/cluster/${var.NOME}-EKS" = "owned"
    "kubernetes.io/service-name"           = "kube-system/aws-load-balancer-controller"
  }
  # Alternatively, if you know the LB name directly
  # name = "k8s-default-appingre-xxxxxxxxxx"
}

# Create the REST API Gateway
resource "aws_api_gateway_rest_api" "lanchonete_api" {
  name        = "${var.NOME}-API"
  description = "API Gateway para microserviços de lanchonete no EKS"
  
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Create resources for each microservice
# 1. Cliente Microservice
resource "aws_api_gateway_resource" "cliente" {
  rest_api_id = aws_api_gateway_rest_api.lanchonete_api.id
  parent_id   = aws_api_gateway_rest_api.lanchonete_api.root_resource_id
  path_part   = "cliente"
}

# 2. Pedido Microservice
resource "aws_api_gateway_resource" "pedido" {
  rest_api_id = aws_api_gateway_rest_api.lanchonete_api.id
  parent_id   = aws_api_gateway_rest_api.lanchonete_api.root_resource_id
  path_part   = "pedido"
}

# 3. Cozinha Microservice
resource "aws_api_gateway_resource" "cozinha" {
  rest_api_id = aws_api_gateway_rest_api.lanchonete_api.id
  parent_id   = aws_api_gateway_rest_api.lanchonete_api.root_resource_id
  path_part   = "cozinha"
}

# Configure proxy resources for each service to catch all sub-paths
resource "aws_api_gateway_resource" "cliente_proxy" {
  rest_api_id = aws_api_gateway_rest_api.lanchonete_api.id
  parent_id   = aws_api_gateway_resource.cliente.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_resource" "pedido_proxy" {
  rest_api_id = aws_api_gateway_rest_api.lanchonete_api.id
  parent_id   = aws_api_gateway_resource.pedido.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_resource" "cozinha_proxy" {
  rest_api_id = aws_api_gateway_rest_api.lanchonete_api.id
  parent_id   = aws_api_gateway_resource.cozinha.id
  path_part   = "{proxy+}"
}

# Define methods for each service (ANY method to handle all HTTP methods)
# Cliente
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

# Pedido
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

# Cozinha
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

# Define integrations with the EKS load balancer
# Cliente Integration
resource "aws_api_gateway_integration" "cliente_integration" {
  rest_api_id             = aws_api_gateway_rest_api.lanchonete_api.id
  resource_id             = aws_api_gateway_resource.cliente.id
  http_method             = aws_api_gateway_method.cliente_any.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.aws_lb.eks_lb.dns_name}/cliente"
  
  # Pass all request parameters through to the backend
  request_parameters = {
    "integration.request.header.X-Forwarded-For" = "method.request.header.X-Forwarded-For"
  }
}

resource "aws_api_gateway_integration" "cliente_proxy_integration" {
  rest_api_id             = aws_api_gateway_rest_api.lanchonete_api.id
  resource_id             = aws_api_gateway_resource.cliente_proxy.id
  http_method             = aws_api_gateway_method.cliente_proxy_any.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.aws_lb.eks_lb.dns_name}/cliente/{proxy}"
  
  # Pass all request parameters through to the backend
  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

# Pedido Integration
resource "aws_api_gateway_integration" "pedido_integration" {
  rest_api_id             = aws_api_gateway_rest_api.lanchonete_api.id
  resource_id             = aws_api_gateway_resource.pedido.id
  http_method             = aws_api_gateway_method.pedido_any.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.aws_lb.eks_lb.dns_name}/pedido"
  
  # Pass all request parameters through to the backend
  request_parameters = {
    "integration.request.header.X-Forwarded-For" = "method.request.header.X-Forwarded-For"
  }
}

resource "aws_api_gateway_integration" "pedido_proxy_integration" {
  rest_api_id             = aws_api_gateway_rest_api.lanchonete_api.id
  resource_id             = aws_api_gateway_resource.pedido_proxy.id
  http_method             = aws_api_gateway_method.pedido_proxy_any.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.aws_lb.eks_lb.dns_name}/pedido/{proxy}"
  
  # Pass all request parameters through to the backend
  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

# Cozinha Integration
resource "aws_api_gateway_integration" "cozinha_integration" {
  rest_api_id             = aws_api_gateway_rest_api.lanchonete_api.id
  resource_id             = aws_api_gateway_resource.cozinha.id
  http_method             = aws_api_gateway_method.cozinha_any.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.aws_lb.eks_lb.dns_name}/cozinha"
  
  # Pass all request parameters through to the backend
  request_parameters = {
    "integration.request.header.X-Forwarded-For" = "method.request.header.X-Forwarded-For"
  }
}

resource "aws_api_gateway_integration" "cozinha_proxy_integration" {
  rest_api_id             = aws_api_gateway_rest_api.lanchonete_api.id
  resource_id             = aws_api_gateway_resource.cozinha_proxy.id
  http_method             = aws_api_gateway_method.cozinha_proxy_any.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${data.aws_lb.eks_lb.dns_name}/cozinha/{proxy}"
  
  # Pass all request parameters through to the backend
  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

# Deploy the API Gateway
resource "aws_api_gateway_deployment" "lanchonete_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.cliente_integration,
    aws_api_gateway_integration.cliente_proxy_integration,
    aws_api_gateway_integration.pedido_integration,
    aws_api_gateway_integration.pedido_proxy_integration,
    aws_api_gateway_integration.cozinha_integration,
    aws_api_gateway_integration.cozinha_proxy_integration
  ]
  
  rest_api_id = aws_api_gateway_rest_api.lanchonete_api.id
  
  triggers = {
    # Ensure redeployment when the integrations change
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.cliente.id,
      aws_api_gateway_resource.cliente_proxy.id,
      aws_api_gateway_resource.pedido.id,
      aws_api_gateway_resource.pedido_proxy.id,
      aws_api_gateway_resource.cozinha.id,
      aws_api_gateway_resource.cozinha_proxy.id,
      aws_api_gateway_method.cliente_any.id,
      aws_api_gateway_method.cliente_proxy_any.id,
      aws_api_gateway_method.pedido_any.id,
      aws_api_gateway_method.pedido_proxy_any.id,
      aws_api_gateway_method.cozinha_any.id,
      aws_api_gateway_method.cozinha_proxy_any.id,
      aws_api_gateway_integration.cliente_integration.id,
      aws_api_gateway_integration.cliente_proxy_integration.id,
      aws_api_gateway_integration.pedido_integration.id,
      aws_api_gateway_integration.pedido_proxy_integration.id,
      aws_api_gateway_integration.cozinha_integration.id,
      aws_api_gateway_integration.cozinha_proxy_integration.id
    ]))
  }
  
  lifecycle {
    create_before_destroy = true
  }
}

# Create a stage for the API
resource "aws_api_gateway_stage" "lanchonete_api_stage" {
  deployment_id = aws_api_gateway_deployment.lanchonete_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.lanchonete_api.id
  stage_name    = "v1"
}
