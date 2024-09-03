locals {
  namespaced_department_name = "${var.department_name}-${var.environment}"
  namespaced_service_name    = "${var.service_name}-${var.environment}"

  account_id = data.aws_caller_identity.current.account_id

  # ECS
  container_name          = "${local.namespaced_service_name}-container"
  app_image               = var.ecs.app_image != "" ? var.ecs.app_image : "${data.terraform_remote_state.ecr.outputs.repository_url}:${data.terraform_remote_state.ecr.outputs.version}"
  # autoscaling_resource_id = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"

 # Network 
  vpc = data.terraform_remote_state.network.outputs.vpc
  subnets = data.terraform_remote_state.network.outputs.subnets
  
  # Database
  db_host = data.terraform_remote_state.db.outputs.database_endpoint
  db_name = data.terraform_remote_state.db.outputs.database_name
  db_user = data.terraform_remote_state.db.outputs.database_username
  db_port = data.terraform_remote_state.db.outputs.database_port
  db_pass = jsondecode(data.aws_secretsmanager_secret_version.rds_password.secret_string)["password"]

  common_tags = {
    Project    = "AWS ECS Fargate with Terraform"
    Component  = "ECS Fargate"
    CreatedAt  = "2024-09-03"
    ManagedBy  = "Terraform"
    Owner      = "Vinicius Silva"
    Env        = var.environment
    Repository = "https://github.com/viniciusjs07/terraform-nodejs-todo-api",
  }

}