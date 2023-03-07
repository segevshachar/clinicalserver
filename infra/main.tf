
locals {
  # Set up environment target by workspace name
  environment_name       = terraform.workspace == "default" ? "prod" : terraform.workspace
  prefix_subdomain       = terraform.workspace == "default" ? "" : "${terraform.workspace}."
  redirect_api_subdomain = terraform.workspace == "default" ? "api" : "api-${terraform.workspace}"
  lb_certificate         = "arn:aws:acm:us-east-2:221449258847:certificate/a76f3234-0497-415b-bbf9-cfe97c98a1f2"
  aws_region             = "us-east-2"
}

module "vpc" {
  source = "./modules/vpc"

  environment = local.environment_name
  aws_region  = local.aws_region
}


module "sg" {
  source = "./modules/sg"

  environment = local.environment_name
  vpc_id      = module.vpc.vpc_id
}

module "alb" {
  source = "./modules/alb"

  environment      = local.environment_name
  prefix_subdomain = local.prefix_subdomain
  vpc_id           = module.vpc.vpc_id
  sg_id            = module.sg.default_aws_security_group_id
  subnets          = module.vpc.public_subnets
  acm_arn          = local.lb_certificate
}

module "ecs" {
  source = "./modules/ecs"

  environment      = local.environment_name
  vpc_id           = module.vpc.vpc_id
  sg_id            = module.sg.aws_security_group_id
  subnets          = module.vpc.public_subnets
  aws_region       = local.aws_region
  target_group_arn = module.alb.aws_lb_target_group_id

  depends_on = [module.alb]
}


