# 🍔 Lanchonete PosFiap 
![](https://img.shields.io/badge/Amazon_AWS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white) ![](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white) ![](https://img.shields.io/badge/JavaScript-323330?style=for-the-badge&logo=javascript&logoColor=F7DF1E) ![](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)

## Sobre o Projeto

Esse e um projeto do Tech Challenge fiap, sobre uma uma lanchonete de bairro que está expandindo devido seu grande sucesso. Implementar um sistema de controle de pedidos, possa atender os clientes de maneira eficiente, gerenciando seus pedidos e estoques de forma adequada


Este repositório contém a configuração de infraestrutura como código para o projeto `Lambda e Api Gateware`, utilizando o Terraform para gerenciar e provisionar recursos em nuvem AWS.

## Tecnologias Utilizadas

- **Lambda**: Javascript
- **Infrastrutura**: Terraform
- **CI/CD** : GitHub Action


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
- Node instalado na versão 22

## Como Usar

1. **Clonar o repositório:**

   ```bash
   git clone https://github.com/Outrora/pos-lambda.git
   cd pos-lambda 
    ```

2. **Rodar o Projeto**
    ```bash
    ./run.sh
   ```






