#get account aws
data "aws_caller_identity" "current" {}

data "terraform_remote_state" "network" {
    backend = "s3"

    config = {
     bucket = "terraform-state-2024-${data.aws_caller_identity.current.account_id}"
     key = "aws-ecs-fargate-terraform/${var.environment}/network/terraform.tfstate"
     region = var.aws_region
    }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]

  tags = {
  "Name" = local.namespaced_service_name
  }
  
}
