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
}

data "aws_caller_identity" "current" {}

locals {
  account_id  = data.aws_caller_identity.current.account_id
  environment = "dev"
}

locals {
  default_tags = {
    Environment = local.environment
  }
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
  source = "../../modules/ecr"

  ecr_repository_name = var.ecr_repository_name
}

# WIP
# module "eks" {
#   source = "../../modules/eks"
# }