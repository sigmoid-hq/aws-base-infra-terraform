# ECR Repository
resource "aws_ecr_repository" "app" {
  name                 = "${var.repository_name}-${var.environment}"
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    # Enable image scanning on push
    scan_on_push = true
  }

  lifecycle {
    # Prevent accidental repository destruction 
    prevent_destroy = true
  }

  tags = {
    Name = "${var.repository_name}-${var.environment}"
  }
}

resource "aws_ecr_lifecycle_policy" "app" {
  repository = aws_ecr_repository.app.name
  policy = jsonencode({
    rules = [
      {
        # Keep last n images
        rulePriority = 1
        description  = "Keep last ${var.keep_last_n_images} images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = var.keep_last_n_images
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

# Automatically build and push the image to ECR Repository
resource "null_resource" "build_and_push_image" {
  triggers = {
    version = var.app_version
  }

  provisioner "local-exec" {
    command = <<-EOT
            cd ${path.module}/app && \
            aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${var.account_id}.dkr.ecr.${var.region}.amazonaws.com
            docker build --platform linux/amd64 -t ${aws_ecr_repository.app.repository_url}:latest . && \
            docker push ${aws_ecr_repository.app.repository_url}:latest
        EOT
  }

  depends_on = [ aws_ecr_repository.app ]
}
