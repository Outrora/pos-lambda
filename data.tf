data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.NOME}-vpc"]  # Coloque aqui o nome exato da VPC
  }
}

data "aws_security_group" "rds_sg" {
  vpc_id = data.aws_vpc.vpc.id
  name   = "${var.NOME}_rds_sg"
}

data "aws_subnets" "subnets"{
    filter {
        name = "vpc-id"
        values = [data.aws_vpc.vpc.id]
    }
}

data "aws_db_instance" "pos-lanchonete-cliente" {
  db_instance_identifier = "${var.NOME}-cliente"
}

data "aws_subnet" "subnet" {
  for_each = toset(data.aws_subnets.subnets.ids)
  id       = each.value
}

data "aws_iam_role" "labrole" {
  name = "LabRole"
}

output "labrole_arn" {
  value = data.aws_iam_role.labrole.arn
}
