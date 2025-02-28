variable "regionDefault" {
  default = "us-east-1"
}

variable "labRole" {
  default = "arn:aws:iam::239569854352:role/LabRole"
}

variable "accessConfig" {
  default = "API_AND_CONFIG_MAP"
}


variable "principalArn" {
   default = "arn:aws:iam::142712539440:role/voclabs"
}

variable "policyArn" {
  default = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
}

variable "NOME" {}

variable "TAGS" {}

variable "DB_USER" {}

variable "DB_PASSWORD" {}