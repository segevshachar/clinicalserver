
module "task_def" {
  source                   = "../task_def"
  name                     = var.name
  environment              = var.environment
  container_port           = var.container_port
  target_group_arn         = var.target_group_arn
  tasks_execution_role_arn = var.tasks_execution_role_arn
  tasks_role_arn           = var.tasks_role_arn
  aws_region               = var.aws_region
}


resource "aws_ecs_service" "this" {
  cluster = "${var.environment}-ecs"

  deployment_circuit_breaker {
    enable   = "false"
    rollback = "false"
  }

  deployment_controller {
    type = "ECS"
  }

  deployment_maximum_percent         = "200"
  deployment_minimum_healthy_percent = "100"
  desired_count                      = local.desire_count
  enable_ecs_managed_tags            = "true"
  enable_execute_command             = "false"
  health_check_grace_period_seconds  = "0"
  launch_type                        = "FARGATE"

  load_balancer {
    container_name   = "${var.environment}-${var.name}"
    container_port   = var.container_port
    target_group_arn = var.target_group_arn
  }

  name = "${var.environment}-${var.name}-service"

  network_configuration {
    assign_public_ip = "true"
    security_groups  = [var.sg_id]
    subnets          = var.subnets
  }

  platform_version    = "LATEST"
  scheduling_strategy = "REPLICA"
  task_definition     = module.task_def.task_definition

  tags = {
    Name        = "${var.environment} ECS Service"
    Environment = var.environment
    Automation  = "Terraform"
  }
}


resource "aws_cloudwatch_log_group" "this" {
  name = "/ecs/${var.environment}-${var.name}"
}
