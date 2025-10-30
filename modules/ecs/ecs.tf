locals {
  cluster_name     = "${var.prefix}-${var.project_name}-${var.environment}-ecs-cluster"
  app_service_name = "${var.prefix}-${var.project_name}-${var.environment}-app"
  task_family      = "${local.app_service_name}-taskdef"
  container_image  = "${aws_ecr_repository.app.repository_url}:latest"

  task_definition_template = templatefile("${path.module}/taskdef/app.json", {
    family             = local.task_family
    execution_role_arn = var.task_execution_role_arn
    container_image    = local.container_image
    log_group          = aws_cloudwatch_log_group.app.name
    aws_region         = var.region
    log_stream_prefix  = var.log_stream_prefix
  })

  task_definition = jsondecode(local.task_definition_template)
}

# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = local.cluster_name

  setting {
    name  = "containerInsights"
    value = var.container_insights
  }

  tags = {
    Name = local.cluster_name
  }
}

# ECS Fargate Capacity provider
resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    base              = 0
    weight            = 100
  }
}

# Taskdef for app
resource "aws_ecs_task_definition" "app" {
  family                   = local.task_definition.family
  network_mode             = local.task_definition.networkMode
  requires_compatibilities = local.task_definition.requiresCompatibilities
  cpu                      = local.task_definition.cpu
  memory                   = local.task_definition.memory
  execution_role_arn       = length(trimspace(local.task_definition.executionRoleArn)) > 0 ? local.task_definition.executionRoleArn : null
  container_definitions    = jsonencode(local.task_definition.containerDefinitions)

  tags = {
    Name = local.app_service_name
  }

  depends_on = [aws_ecr_repository.app]
}

# CloudWatch Log Group for app
resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/ecs/${local.app_service_name}"
  retention_in_days = var.log_retention_in_days

  tags = {
    Name = local.app_service_name
  }
}

# ECS Service for app
resource "aws_ecs_service" "app" {
  name             = local.app_service_name
  cluster          = aws_ecs_cluster.main.name
  task_definition  = aws_ecs_task_definition.app.arn
  desired_count    = var.desired_count
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    subnets         = var.service_subnet_ids
    security_groups = [aws_security_group.service.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "app"
    container_port   = 8000
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  tags = {
    Name = local.app_service_name
  }

  depends_on = [aws_ecs_task_definition.app, aws_lb_target_group.app]
}
