resource "aws_vpc" "this" {
  # ip range
  cidr_block           = var.network.cidr_block # https://cidr.xyz
  enable_dns_support   = local.enable_dns_support
  enable_dns_hostnames = local.enable_dns_hostnames

  tags = {
    "Name" = local.namespaced_department_name
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    "Name" = local.namespaced_department_name
  }

}