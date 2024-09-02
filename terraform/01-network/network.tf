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

resource "aws_subnet" "private" {
    count = var.network.az_count
    # cidrsubnet = function terraform
    # 8 bits subnet
    # https://developer.hashicorp.com/terraform/language/functions/cidrsubnet
    cidr_block = cidrsubnet(aws_vpc.this.cidr_block, 8, count.index)
    availability_zone = local.selected_availability_zones[count.index]
    vpc_id =  aws_vpc.this.id
      tags = {
      "Name" = "${local.namespaced_department_name}-private-${local.selected_availability_zones[count.index]}"
  }
}

resource "aws_subnet" "public" {
    count = var.network.az_count
    # cidrsubnet = function terraform
    # 8 bits subnet
    # https://developer.hashicorp.com/terraform/language/functions/cidrsubnet
    cidr_block = cidrsubnet(aws_vpc.this.cidr_block, 8, var.network.az_count + count.index)
    availability_zone = local.selected_availability_zones[count.index]
    vpc_id =  aws_vpc.this.id
      tags = {
      "Name" = "${local.namespaced_department_name}-public-${local.selected_availability_zones[count.index]}"
  }
}

resource "aws_route" "internet_access" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id =  aws_vpc.this.main_route_table_id
  gateway_id =  aws_internet_gateway.this.id
}

resource "aws_route_table" "public" {
    count = var.network.az_count
    vpc_id = aws_vpc.this.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.this.id
    }

    tags = {
      "Name" = "${local.namespaced_department_name}-public-${local.selected_availability_zones[count.index]}"
    }
}

resource "aws_route_table" "private" {
    count = var.network.az_count
    vpc_id = aws_vpc.this.id
    # route table private not have route access
    tags = {
      "Name" = "${local.namespaced_department_name}-private-${local.selected_availability_zones[count.index]}"
    }
}

# Associating route tables with your subnets 
resource "aws_route_table_association" "public" {
        count = var.network.az_count
        route_table_id = aws_route_table.public.*.id[count.index]
        subnet_id = aws_subnet.public.*.id[count.index]
  
}

resource "aws_route_table_association" "private" {
        count = var.network.az_count
        route_table_id = aws_route_table.private.*.id[count.index]
        subnet_id = aws_subnet.private.*.id[count.index]
  
}