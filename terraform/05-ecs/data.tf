#get account aws
data "aws_caller_identity" "current" {}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "terraform-state-2024-${data.aws_caller_identity.current.account_id}"
    key    = "aws-ecs-fargate-terraform/${var.environment}/network/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "ecr" {
  backend = "s3"

  config = {
    bucket = "terraform-state-2024-${data.aws_caller_identity.current.account_id}"
    key    = "aws-ecs-fargate-terraform/${var.environment}/ecr/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = "terraform-state-2024-${data.aws_caller_identity.current.account_id}"
    key    = "aws-ecs-fargate-terraform/${var.environment}/data-base/terraform.tfstate"
    region = var.aws_region
  }
}



