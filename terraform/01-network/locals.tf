locals {
  common_tags = {
      Project = "AWS ECS Fargate with Terraform"
      Component = "Network"
      CreatedAt = "2024-08-29"
      ManagedBy = "Terraform"
      Owner = "Vinicius Silva"
      Env = var.environment
      Repository = "",
  }
}