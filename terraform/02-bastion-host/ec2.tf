resource "aws_security_group" "this" {
    name = "${local.namespaced_service_name}-bastion-host"
    description = "Allows SSH connections from my local machine"
    vpc_id = local.vpc.id

    #regras de entrada
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.allowed_id]
    }
    #regras de saida
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    tags = {
      "Name" = local.namespaced_service_name
    }
  
}

resource "aws_instance" "this" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = local.subnets.public.id[0]
    vpc_security_group_ids = [aws_security_group.this.id]

    tags = {
      "Name" = local.namespaced_service_name
    }
  
}