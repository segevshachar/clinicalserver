variable "environment" {
  type        = string
  description = "Environment name"
}

variable "name" {
  type        = string
  description = "Server name"
}

variable "container_port" {
  type        = number
  description = "Docker container port for server"
}

variable "vpc_id" {
  type        = string
  description = "ID of VPC"
}

variable "sg_id" {
  type        = string
  description = "ID of Security group in VPC"
}

variable "target_group_arn" {
  type        = string
  description = "ARN of target group"
}

variable "tasks_execution_role_arn" {
  type        = string
  description = "Task execution role ARN"
}

variable "tasks_role_arn" {
  type        = string
  description = "Task role ARN"
}

variable "subnets" {
  type        = list(string)
  description = "Subnets to be in"
}

variable "aws_region" {
  type = string
}
