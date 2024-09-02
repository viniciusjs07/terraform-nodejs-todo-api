variable "aws_region" {
   description = "AWS region where the Network resources will be deployed, e.g, 'us-east-1' for the Northern Virginia"
   type = string
   default = "us-east-1"
}

variable "environment" {
   description = "Deployment environment name, such as 'dev', 'test', 'prod'. This categorizes the Network resources by their usage stage"
   type = string
   default = "dev"
}