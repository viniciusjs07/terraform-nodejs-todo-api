variable "aws_region" {
  description = "AWS region where the Network resources will be deployed, e.g, 'us-east-1' for the Northern Virginia"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment name, such as 'dev', 'test', 'prod'. This categorizes the Network resources by their usage stage"
  type        = string
  default     = "dev"
}

variable "service_name" {
  description = "Name of the service the bastion host is associated with, used for naming and tagging resources in AWS"
  type        = string
  default     = "express-todos-api"
}

variable "department_name" {
  description = "Name of the department responsible for the VPC, e.g., 'engineering', 'marketing'. Helps in identifying ownership of the resources"
  type        = string
  default     = "engineering" # marketing, sales, operations, hr, etc
}
