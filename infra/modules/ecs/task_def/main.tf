
resource "aws_ecs_task_definition" "this" {
  container_definitions    = "[{\"cpu\":0,\"environment\":[{\"name\":\"NODE_ENV\",\"value\":\"${var.environment}\"}],\"essential\":true,\"image\":\"221449258847.dkr.ecr.us-east-2.amazonaws.com/server:latest\",\"logConfiguration\":{\"logDriver\":\"awslogs\",\"options\":{\"awslogs-group\":\"/ecs/${var.environment}-${var.name}\",\"awslogs-region\":\"${var.aws_region}\",\"awslogs-stream-prefix\":\"ecs\"}},\"mountPoints\":[],\"name\":\"${var.environment}-${var.name}\",\"portMappings\":[{\"containerPort\":${var.container_port},\"hostPort\":${var.container_port},\"protocol\":\"tcp\"}],\"volumesFrom\":[]}]"
  cpu                      = "256"
  execution_role_arn       = var.tasks_execution_role_arn
  family                   = "${var.environment}-${var.name}"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = var.tasks_role_arn

  tags = {
    Name        = "${var.environment} ${var.name} Task Definition"
    Environment = var.environment
    Automation  = "Terraform"
  }
}
