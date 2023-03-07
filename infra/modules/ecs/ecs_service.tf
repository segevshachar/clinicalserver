locals {
}

data "aws_iam_policy_document" "ecs_tasks_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_tasks_execution_role" {
  name                = "${var.environment}-ecs-task-execution-role"
  assume_role_policy  = data.aws_iam_policy_document.ecs_tasks_execution_role.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
}

resource "aws_iam_role_policy_attachment" "ecs_tasks_execution_role" {
  role       = aws_iam_role.ecs_tasks_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_role" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  description          = "Allows ECS tasks to call AWS services on your behalf."
  managed_policy_arns  = [aws_iam_policy.this.arn]
  max_session_duration = "3600"
  name                 = "${var.environment}-ecs-task-role"

  tags = {
    Environment = var.environment
    Automation  = "Terraform"
  }
}

resource "aws_iam_policy" "this" {
  name = "${var.environment}-S3-file-access"
  path = "/"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource" : ["arn:aws:s3:::*"]
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}



module "service" {
  source                   = "./service"
  name                     = "service"
  environment              = var.environment
  container_port           = 3000
  vpc_id                   = var.vpc_id
  sg_id                    = var.sg_id
  target_group_arn         = var.target_group_arn
  tasks_execution_role_arn = aws_iam_role.ecs_tasks_execution_role.arn
  tasks_role_arn           = aws_iam_role.ecs_task_role.arn
  subnets                  = var.subnets
  aws_region               = var.aws_region
}

