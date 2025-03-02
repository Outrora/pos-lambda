# Função Lambda
resource "aws_lambda_function" "usuario_api" {
  filename         = "lambda.zip"  # Caminho para o arquivo .zip com o código
  function_name    = "pegarUsuario"
  role             = data.aws_iam_role.labrole.arn  # Role associada à Lambda
  handler          = "main.handler"  # Nome do arquivo e função que será chamada
  runtime          = "nodejs22.x"  # Runtime da função Lambda (pode ser outro, como python3.8, etc.)
  timeout          = 15
  memory_size      = 128
  
  vpc_config {
    subnet_ids = data.aws_subnets.subnets.ids
    security_group_ids = [data.aws_security_group.rds_sg.id]
  }

  environment {
    variables = {
      DB_USER     = var.DB_USER
      DB_HOST     = data.aws_db_instance.pos_lanchonete.address
      DB_NAME     = var.NOME
      DB_PASSWORD = var.DB_PASSWORD
    }
  }
}