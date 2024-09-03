resource "aws_ecr_repository" "this" {
  name                 = local.namespaced_department_name
  image_tag_mutability = "IMMUTABLE"
  force_delete         = var.force_delete_repo
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 5 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 5
      }
    }]
  })
}

# Push images docker from ECR AWS
resource "terraform_data" "build_image" {
  triggers_replace = {
    hash = local.service_file_hash
  }

  # command = está no opção View push commands dentro do ECR criado no console aws
  provisioner "local-exec" {
    working_dir = var.app_folder
    command     = <<EOT
      aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${local.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com
    EOT
  }

 # realizando build sem services/api/ da aplicação nodejs
  provisioner "local-exec" {
    working_dir = var.app_folder
    command     = "docker build -t ${local.namespaced_service_name} ."
  }

  provisioner "local-exec" {
    working_dir = var.app_folder
    command     = "docker tag ${local.namespaced_service_name} ${aws_ecr_repository.this.repository_url}:${random_id.version.id}"
  }

  provisioner "local-exec" {
    working_dir = var.app_folder
    command     = "docker push ${aws_ecr_repository.this.repository_url}:${random_id.version.id}"
  }
}



