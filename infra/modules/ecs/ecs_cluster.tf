resource "aws_ecs_cluster" "this" {
  capacity_providers = ["FARGATE"]
  name               = "${var.environment}-ecs"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name        = "${var.environment}-ecs"
    Environment = var.environment,
    Automation  = "Terraform"
  }
}
