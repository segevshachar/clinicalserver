variable "environment" {
  type        = string
  description = "Environment name"
}

variable "vpc_id" {
  type        = string
  description = "ID of VPC"
}

variable "sg_id" {
  type        = string
  description = "ID of Security group in VPC"
}

variable "subnets" {
  type        = list(string)
  description = "Subnets to be in"
}

variable "aws_region" {
  type = string
}

variable "target_group_arn" {
  type        = string
  description = "ARN of target group ARN"
}

