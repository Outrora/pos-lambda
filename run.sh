#!/bin/bash

# Obtém a versão do Node.js
NODE_VERSION=$(node -v)

rodarProjeto() {

    if test -f "lambda.zip"; then
        rm -f lambda.zip
    fi

    cd projeto || { echo "Diretório 'projeto' não encontrado."; exit 1; }
    
    echo "Instalando dependências com npm..."
    npm i || { echo "Falha ao executar 'npm i'."; exit 1; }

    echo "Criando arquivo zip do projeto..."
    zip -r ../lambda.zip . || { echo "Falha ao criar o arquivo zip."; exit 1; }

    cd ..
    terraform init 

    echo "Aplicando o Terraform..."
    terraform apply -var="TAGS=lachonete" -var="NOME=lanchonete" -var="DB_USER=test"  -var="DB_PASSWORD=test" -auto-approve
}


if [[ "$NODE_VERSION" == v22* ]]; then
    if command -v terraform &> /dev/null; then
        rodarProjeto
    else
        echo "Terraform não está instalado."
    fi
else
    echo "A versão do Node.js não é 22. A versão atual é: $NODE_VERSION"
fi



