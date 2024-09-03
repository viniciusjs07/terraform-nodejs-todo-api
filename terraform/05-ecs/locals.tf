locals {
  namespaced_department_name = "${var.department_name}-${var.environment}"
  namespaced_service_name    = "${var.service_name}-${var.environment}"

  account_id = data.aws_caller_identity.current.account_id

 # Network 
  vpc = data.terraform_remote_state.network.outputs.vpc
  subnets = data.terraform_remote_state.network.outputs.subnets
  
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