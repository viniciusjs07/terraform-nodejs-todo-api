locals {
  namespaced_service_name = "${var.service_name}-${var.environment}"

  # Network 
  vpc = data.terraform_remote_state.network.outputs.vpc
  subnets = data.terraform_remote_state.network.outputs.subnets
  
  common_tags = {
    Project    = "AWS ECS Fargate with Terraform"
    Component  = "Bastion Host"
    CreatedAt  = "2024-08-29"
    ManagedBy  = "Terraform"
    Owner      = "Vinicius Silva"
    Env        = var.environment
    Repository = "https://github.com/viniciusjs07/terraform-nodejs-todo-api",
  }

}