# Configuração

Requisitos:
 - Instalação do terraform: [https://developer.hashicorp.com/terraform/install]
 - Instalação do AWS CLI: [https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html]
 - Ter uma conta na AWS e criar um perfil para seu usuário
 - Inserir a permissão no usuário: AdministratorAccess
 - Terminal do windows rode: aws configure --profile <YourProfile> e insira suas credenciais da aws
 

Criação dos serviços iniciais na aws que são necessários para inserir o remote state (estado remoto) do terraform.
Os serviços iniciais para o remote state que está na pasta [/00-remote-state] incluem:
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

 Estrutura de Pastas do [terraform]:
  # 00-remote-state (Configruração inicial do estado remoto do terraform)
  # 01-network (após criar a VPC no console aws deve seguir esses passos)
    - criar pasta: [config/dev/backend.hcl] (hashcorp) configuração do seu bucket s3, region, profile e seu dynamodb aqui
    - Segue o arquivo backend-example para copiar e colar no seu arquivo backend.hcl e preencher com seus dados.
    - Após configurar o network com o arquivo backend.hcl:
      - Ir na pasta via terminal em 01-network
      - rodar o comando: terraform init -backend=true -backend-config="config/dev/backend.hcl"
      - rodar: terraform validate
      - rodar: terraform plan
  # Criando VPC e Internet Gateway 
   - Criando arquivo [network.tf] para configurar o recurso da vpc
   -migrate-state
   - Rodar: terraform init -backend=true -backend-config="config/dev/backend.hcl"
   - Caso ocorre error, rodar: terraform init -migrate-state -backend=true -backend-config="config/dev/backend.hcl"
   - terraform plan
  # Criando Subnet
    - Dentro do arquio [network.tf] é inserido a subnet privada e publica com suas respectivas variáveis de ambiente.
    - Comandos: terraform plan (dentro da pasta 01-network)
    - terraform validate
    - terraform apply -auto-approve
  
  # Configurando router tables VPC
   - Precisamos configurar no arquivo [network.tf] as tabelas de rotas da AWS VPC para identificar quais rotas serão public e quais serão privadas
   - Criando aws_route = internet access
   - Criando aws_route_table public e inserindo a rota com o aws_internet_gateway
   - Criando aws_route_table privada sem a rota com o aws_internet_gateway
   - Criando aws_route_table_association publica e privada com a integração do aws_route_table e aws_subnet
   - Comandos: terraform plan (dentro da pasta 01-network)
   - terraform validate
   - terraform apply -auto-approve

# Configurando VPC endpoint (Network associations)
   - Precisamos configurar no arquivo [network.tf] o module vpc_endpoints com as routes tables privadas e subnets privadas
   - Criando path modules/vpc_endpoint com os arquivos [main.tf], [variables.tf] e [outputs.tf]
    - [main.tf] - recursos aws_security_group, aws_vpc_endpoint para logs, aws_vpc_endpoint ecr_dkr, aws_vpc_endpoint ecr_api e aws_vpc_endpoint s3
    - [outptus.tf] - criando output para endpoints de endpoint_s3, endpoint_ecr_dkr, endpoint_ecr_api e endpoint_logs (cloudWhatch)
    - Comandos: 
      - terraform init -backend=true -backend-config="config/dev/backend.hcl"
      - terraform validate
      - terraform plan
    - Criando arquivo [terraform.tfvars] em 01-network/config/dev/terraform.tfvars
      - terraform plan -var-file="config/dev/terraform.tfvars"
      - terraform apply -var-file="config/dev/terraform.tfvars" -auto-approve

   # Configurando Bastion Host service
    - Criamos a pasta 02-bastion-host e seus respectivos arquivos.
    - Criando security group para EC2
    - plan -var-file="config/dev/terraform.tfvars"
    - insert your IP Address from ec2 console aws
    - terraform apply -var-file="config/dev/terraform.tfvars" -auto-approve
    - insert your IP Address from ec2 console aws
    - Criamos o security group : express-todos-api=dev

  # Configurando EC2 para o Bastion Host service
    - Criando recurso aws_instance em [ec2.tf]
    - Cria um novo par de chave com um nome na ec2 da aws console
    - Em EC2 na aws console vá em security groups e obtenha seu ip.
    - terraform init -var-file="config/dev/terraform.tfvars"
    - terraform validade
    - terraform plan -var-file="config/dev/terraform.tfvars" -var allowed_id="YOUR_IP_AWS" -var key_name="YOUR_KEY_PAIR_EC2_AWS"
    - terraform apply -var-file="config/dev/terraform.tfvars" -var allowed_id="YOUR_IP_AWS" -var key_name="YOUR_KEY_PAIR_EC2_AWS" -auto-approve

