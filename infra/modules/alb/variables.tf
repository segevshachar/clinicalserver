variable "environment" {
  type        = string
  description = "Environment name"
}

variable "vpc_id" {
  type        = string
  description = "ID of the environment VPC"
}

variable "sg_id" {
  type        = string
  description = "ID of SG"
}

variable "subnets" {
  type        = list(string)
  description = "Subnets to be in"
}

variable "acm_arn" {
  type        = string
  description = "acm arn"
}

variable "prefix_subdomain" {
  type = string
}
