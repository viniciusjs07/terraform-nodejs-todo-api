locals {
  namespaced_service_name = "${var.service_name}-${var.environment}"

  # Network 
  vpc     = data.terraform_remote_state.network.outputs.vpc
  subnets = data.terraform_remote_state.network.outputs.subnets

  # security_group_id in 02-bastion-host/outputs.tf
  # check is exist data.terraform_remote_state.bastion_host.outputs
  # if not exist, then return empty
  bastion_host_sg_id = lookup(data.terraform_remote_state.bastion_host.outputs, "security_group_id", "")

  availability_zones = data.terraform_remote_state.network.outputs.selected_availability_zones

  common_tags = {
    Project    = "AWS ECS Fargate with Terraform"
    Component  = "Database"
    CreatedAt  = "2024-08-29"
    ManagedBy  = "Terraform"
    Owner      = "Vinicius Silva"
    Env        = var.environment
    Repository = "https://github.com/viniciusjs07/terraform-nodejs-todo-api",
  }

}