#data "aws_vpc" "vpc" {
#  filter {
#    name   = "tag:Name"
#    values = ["${var.NOME}-vpc"]  # Coloque aqui o nome exato da VPC
#  }
#}

#data "aws_subnets" "subnets"{
#    filter {
#        name = "vpc-id"
#        values = [data.aws_vpc.vpc.id]
#    }
#}

#data "aws_subnet" "subnet" {
#  for_each = toset(data.aws_subnets.subnets.ids)
#  id       = each.value
#}

data "aws_iam_role" "labrole" {
  name = "LabRole"
}

output "labrole_arn" {
  value = data.aws_iam_role.labrole.arn
}
