# Lanchonete
## Lambda e Api Gateware

Este repositório contém a configuração de infraestrutura como código para o projeto `Lambda e Api Gateware`, utilizando o Terraform para gerenciar e provisionar recursos em nuvem AWS.

## Estrutura do Repositório

- **`main.tf`**: Arquivo principal que define os recursos a serem provisionados.
- **`provider.tf`**: Configura o provedor de nuvem a ser utilizado pelo Terraform.
- **`vars.tf`**: Define as variáveis de entrada para parametrizar a infraestrutura.
- **`output.tf`**: Especifica as saídas que serão exibidas após a execução do Terraform.
- **`data.tf`**: Declara fontes de dados que podem ser utilizadas para obter informações de recursos existentes.
- **`apiGateway.tf`**: Configura o API Gateway para gerenciar as solicitações HTTP.


## Pré-requisitos

- [Terraform](https://www.terraform.io/downloads.html) instalado na máquina local.
- Conta ativa no provedor de nuvem aws.

## Como Usar

1. **Clonar o repositório:**

   ```bash
   git clone https://github.com/Outrora/pos-lambda.git
   cd pos-lambda 
    ```

2. **Rodar o Projeto**
    ```bash
    ./run.sh