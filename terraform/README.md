# Configuração

Requisitos:
 - Instalação do terraform: [https://developer.hashicorp.com/terraform/install]
 - Instalação do AWS CLI: [https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html]
 - Ter uma conta na AWS e criar um perfil para seu usuário
 - Inserir a permissão no usuário: AdministratorAccess
 - Terminal do windows rode: aws configure --profile <YourProfile> e insira suas credenciais da aws
 

Criação dos serviços iniciais na aws que são necessários para inserir o remote state (estado remoto) do terraform.
Os serviços iniciais para o remote state incluem:
 - dynamodb.tf (tabela dynamodb aws) para armazenar o lock do remote state
 - providers.tf (configurações da aws)
 - s3.tf (bucket aws s3)
 - versions.tf (versionamento dos serviços)
 - outputs.tf


Após criar e configurar os 4 arquivos:
 - Ir Na pasta 00-remote-state rodar:
  - set AWS_PROFILE=YourProfile (windows)
  - terraform init
  - terraform validate
  - terraform plan (para criar os resources)
  - terraform apply -auto-approve (Para aplicar os recursos na AWS)


Serviços criados na AWS:
 - VPC : Criado via console aws
 - S3
 - DynamoDB