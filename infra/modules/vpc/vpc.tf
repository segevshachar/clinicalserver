module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.10.0"

  name = "${var.environment}-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["${var.aws_region}a", "${var.aws_region}b"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]


  enable_ipv6 = false

  enable_nat_gateway = false
  single_nat_gateway = true

  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  instance_tenancy = "default"

  tags = {
    Name        = "${var.environment}-vpc",
    Environment = var.environment
    Automation  = "Terraform"
  }
}
