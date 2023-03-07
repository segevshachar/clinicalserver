variable "vpc_id" {
  type        = string
  description = "ID of VPC to add security groups to"
}

variable "environment" {
  type        = string
  description = "Environment name"
}
