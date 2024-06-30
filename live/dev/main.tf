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

  default_tags = {
    CreatedBy   = "Terraform"
    Environment = local.environment
    Repository  = "https://github.com/tonyrud/terraform-learn.git"
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

  ecr_repository_name = "java-maven-app"
}

# module "ec2" {
#   source = "../../modules/ec2"

#   my_ip               = var.my_ip
#   instance_type       = "t2.micro"
#   public_key_location = var.public_key_location
#   vpc_id              = module.vpc.vpc_id
# }

# WIP
# module "eks" {
#   source = "../../modules/eks"
# }