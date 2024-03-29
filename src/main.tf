terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

provider "aws" {}

module "vpc" {
  source = "./modules/vpc"
}

module "security_group" {
  source      = "./modules/security_group"
  vpc_id      = module.vpc.vpc_id
  name_prefix = module.vpc.vpc_name
}

module "target_group" {
  source  = "./modules/target_group"
  tg_name = var.project_name
  vpc_id  = module.vpc.vpc_id
}

module "loadbalancer" {
  source         = "./modules/loadbalancer"
  app_subnet_ids = module.vpc.app_subnet_ids
  web_subnet_ids = module.vpc.web_subnet_ids
  vpc_id         = module.vpc.vpc_id
  app_sg_ids = [
    module.security_group.app_sg_id
  ]
  web_sg_ids = [
    module.security_group.web_sg_id
  ]
  app_tg_arn = module.target_group.app_tg_arn
  web_tg_arn = module.target_group.web_tg_arn
}

module "autoscaling_group" {
  source         = "./modules/autoscaling_group"
  app_subnet_ids = module.vpc.app_subnet_ids
  web_subnet_ids = module.vpc.web_subnet_ids
  app_tg_arn     = module.target_group.app_tg_arn
  web_tg_arn     = module.target_group.web_tg_arn
  app_sg_ids = [
    module.security_group.app_sg_id
  ]
  web_sg_ids = [
    module.security_group.web_sg_id
  ]
}

module "rds" {
  source = "./modules/rds"
  rds_sg_ids = [
    module.security_group.db_sg_id
  ]
  rds_subnet_group_name = module.vpc.rds_subnet_group_name
}