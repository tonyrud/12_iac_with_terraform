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

module "vpc" {
  source = "../../modules/vpc"

  vpc_name                   = var.vpc_name
  vpc_cidr                   = var.vpc_cidr
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
}

# java-maven-app
module "ecr" {
  source = "../../modules/ecr"

  ecr_repository_name = var.ecr_repository_name
}