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

# java-maven-app docker image
module "ecr" {
  count  = var.create_ecr ? 1 : 0
  source = "../../modules/ecr"

  ecr_repository_name = "${var.vpc_name}-java-maven-app"
}

module "ec2" {
  count  = var.create_ec2 ? 1 : 0
  source = "../../modules/ec2"

  my_ip               = var.my_ip
  public_key_location = var.public_key_location
  public_subnets      = module.vpc.public_subnets
  vpc_id              = module.vpc.vpc_id
}

module "eks" {
  count           = var.create_eks ? 1 : 0
  source          = "../../modules/eks"
  cluster_name    = "${var.vpc_name}-cluster"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
}