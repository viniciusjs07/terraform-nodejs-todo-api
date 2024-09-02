# https://developer.hashicorp.com/terraform/language/settings/backends/s3

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Project = "AWS ECS Fargate with Terraform"
      Component = "Remote State"
      CreatedAt = "2024-08-29"
      ManagedBy = "Terraform"
      Owner = "Vinicius Silva"
      Repository = "https://github.com/viniciusjs07/terraform-nodejs-todo-api"
    }
  }
}