data "aws_eks_cluster" "eks_cluster" {
  name = "${var.NOME}-EKS"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks_cluster.name]
  }
}
# Data sources para buscar informações sobre os serviços Kubernetes existentes
data "kubernetes_service" "cliente_service" {
  metadata {
    name = "app-service-cliente"
    namespace = "default"
  }
  depends_on = [data.aws_eks_cluster.eks_cluster]
}

data "kubernetes_service" "pedido_service" {
  metadata {
    name = "app-service-pedido"
    namespace = "default"
  }
  depends_on = [data.aws_eks_cluster.eks_cluster]
}

data "kubernetes_service" "cozinha_service" {
  metadata {
    name = "app-service-cozinha"
    namespace = "default"
  }
  depends_on = [data.aws_eks_cluster.eks_cluster]
}

# Outputs para confirmar os endereços dos Load Balancers
output "cliente_load_balancer" {
  value = data.kubernetes_service.cliente_service.status.0.load_balancer.0.ingress.0.hostname
}

output "pedido_load_balancer" {
  value = data.kubernetes_service.pedido_service.status.0.load_balancer.0.ingress.0.hostname
}

output "cozinha_load_balancer" {
  value = data.kubernetes_service.cozinha_service.status.0.load_balancer.0.ingress.0.hostname
}