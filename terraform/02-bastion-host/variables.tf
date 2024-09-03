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

variable "allowed_id" {
  description = "IP address/CIDR block allowed to SSH into the bastion host. Use caution to restrict access to know IPs for security"
  type        = string
}
variable "instance_type" {
  description = "The EC2 instance type for the bastion host, such as 't2.micro'. This determines the hardware of the host"
  type        = string
  default = "t2.micro"
}
variable "key_name" {
  description = "The name of SSH key pair used to acces the bastion host. Ensure the key exists in AWS EC2 before deployment"
  type        = string
}


