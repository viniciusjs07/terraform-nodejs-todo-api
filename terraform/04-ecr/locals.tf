locals {
  namespaced_department_name = "${var.department_name}-${var.environment}"
  namespaced_service_name    = "${var.service_name}-${var.environment}"

  # service_file_hash = qualquer atualização dentro da aplicação nodejs dentro de /src será disparado uma nova build
  # E o ECR vai gerar uma nova imagem
  service_file_hash = sha1(join("", [for file in fileset("${var.app_folder}/src", "**") : filesha1("${var.app_folder}/src/${file}")]))

  account_id = data.aws_caller_identity.current.account_id

  common_tags = {
    Project    = "AWS ECS Fargate with Terraform"
    Component  = "ECR"
    CreatedAt  = "2024-09-03"
    ManagedBy  = "Terraform"
    Owner      = "Vinicius Silva"
    Env        = var.environment
    Repository = "https://github.com/viniciusjs07/terraform-nodejs-todo-api",
  }

}