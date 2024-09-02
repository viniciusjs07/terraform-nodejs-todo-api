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

variable "department_name" {
  description = "Name of the department responsible for the VPC, e.g., 'engineering', 'marketing'. Help is indentifying ownership of the resources"
  type        = string
  default     = "engineering" #marketing, sales, operation, hr, etc. 
}

variable "network" {
  description = <<-EOT
                General configuration for the network, including:
                  - az_count: Number of availability zones to use.
                  - cidr_block: IPv4 CIDR block for the VPC, e.g., '10.1.0.0/16'.
                  - enable_dns_support: Whether to enable DNS support (true or false).
                  - enable_dns_hostnames: Whether to enable DNS hostnames (true or false).
                EOT

  type = object({
    az_count             = number
    cidr_block           = string
    enable_dns_support   = bool
    enable_dns_hostnames = bool
  })

  default = {
    az_count             = 2
    cidr_block           = "10.1.0.0/16" # CIDR IPv4 aws vpc
    enable_dns_support   = false
    enable_dns_hostnames = false
  }

  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", var.network.cidr_block))
    error_message = "The CIDR block is not in a valid format."
  }

  validation {
    condition     = var.network.az_count > 0 && var.network.az_count <= 3
    error_message = "The number of availability zones must be between 1 and 3."
  }
}

variable "use_nat_gateway" {
  description = "Whether to use NAT Gateway to connect the private subnet(s) to the internet or not. Conflicts with use_nat_instance. Setting both to true is not allowed. Choose one based on the cost and performance needs of your environment"
  type        = bool
  default     = false
}

variable "use_nat_instance" {
  description = "Whether to use NAT Instances to connect the private subnet(s) to the internet or not. Conflicts with use_nat_gateway. Setting both to true is not allowed. Choose one based on the cost and performance needs of your environment"
  type        = bool
  default     = false
}

variable "create_vpc_endpoint" {
  description = "Controls the creation of VPC Endpoints for services like S3, Docker, and Cloudwatch. Requires network.enable_dns_support and network.enable_dns_hostnames to be true. Ensuring these prerequisites can enable private access to AWS services without requiring Internet Gateway"
  type        = bool
  default     = false
}