locals {
  namespaced_department_name = "${var.department_name}=${var.environment}"
  use_nat_gateway            = var.use_nat_gateway
  use_nat_instance           = var.use_nat_instance && local.use_nat_gateway == false
  enable_dns_support         = (var.use_nat_instance || var.create_vpc_endpoint) ? true : var.network.enable_dns_support
  enable_dns_hostnames       = (var.use_nat_instance || var.create_vpc_endpoint) ? true : var.network.enable_dns_hostnames
  sorted_availability_zones = sort(data.aws_availability_zones.all.names)
  selected_availability_zones = slice(local.sorted_availability_zones, 0, var.network.az_count)
  common_tags = {
    Project    = "AWS ECS Fargate with Terraform"
    Component  = "Network"
    CreatedAt  = "2024-08-29"
    ManagedBy  = "Terraform"
    Owner      = "Vinicius Silva"
    Env        = var.environment
    Repository = "https://github.com/viniciusjs07/terraform-nodejs-todo-api",
  }

}