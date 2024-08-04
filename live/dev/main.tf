terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.46.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Owner       = "Terraform"
      Environment = "dev"
      Repository  = "https://github.com/tonyrud/terraform-learn.git"
    }
  }
}

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

module "vpc" {
  source = "../../modules/vpc"

  vpc_name                   = var.vpc_name
  vpc_cidr                   = var.vpc_cidr
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
}

module "ecr" {
  count  = length(var.ecr_names)
  source = "../../modules/ecr"

  ecr_repository_name = var.ecr_names[count.index]
}

module "ec2" {
  count  = length(var.instance_names)
  source = "../../modules/ec2"

  my_ip               = var.my_ip
  public_key_location = var.public_key_location
  public_subnets      = module.vpc.public_subnets
  vpc_id              = module.vpc.vpc_id
  instance_name       = var.instance_names[count.index]
}

module "eks" {
  count           = var.create_k8s_cluster ? 1 : 0
  source          = "../../modules/eks"
  cluster_name    = "${var.vpc_name}-cluster"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
}