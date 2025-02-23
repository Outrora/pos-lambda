# Função Lambda
resource "aws_lambda_function" "usuario_api" {
  filename         = "lambda.zip"  # Caminho para o arquivo .zip com o código
  function_name    = "pegarUsuario"
  role             = data.aws_iam_role.labrole.arn  # Role associada à Lambda
  handler          = "main.handler"  # Nome do arquivo e função que será chamada
  runtime          = "nodejs22.x"  # Runtime da função Lambda (pode ser outro, como python3.8, etc.)
  timeout          = 15
  memory_size      = 128
}