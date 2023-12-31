# provider "aws" {
#     region = "us-east-1"
#     profile = "default"
# }

terraform {
  backend "s3" {
    # bucket  = "northwell-ecs-backend" #ft-dev-terraform-state
    # key     = "northwell-ecs-backend.tfstate"
    # region  = "us-east-1"
  }
}

module "VPC" {
  source     = "../module/VPC"
  vpc        = var.vpc
  prefix     = var.prefix
  env        = var.env
}

module "SG" {
  source     = "../module/SG"
  vpc        = var.vpc
  vpc_id     = module.VPC.vpc_id
  prefix     = var.prefix
  env        = var.env
  sg         = var.sg
}

module "ALB" {
  source     = "../module/ALB"
  vpc        = var.vpc
  alb        = var.alb
  public_subnet_id  = module.VPC.public_subnet_id
  sg_id      = module.SG.sg_id
  vpc_id     = module.VPC.vpc_id
  prefix     = var.prefix
  env        = var.env
}
module "ECS" {
  source               = "../module/ECS"
  vpc                  = var.vpc
  ecs                  = var.ecs
  private_subnet_id    = module.VPC.private_subnet_id
  sg_id                = module.SG.sg_id
  prefix               = var.prefix
  env                  = var.env
  aws_alb_target_group = module.ALB.aws_alb_target_group
}
module "Admin_ECR" {
  source               = "../module/ECR"
  env                  = var.environments.env
  environments         = var.environments.admin
}
module "Server_ECR" {
  source               = "../module/ECR"
  env                  = var.environments.env
  environments         = var.environments.server
}
module "Client_ECR" {
  source               = "../module/ECR"
  env                  = var.environments.env
  environments         = var.environments.client
}

