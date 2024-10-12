terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.46.0"
    }
  }
}

locals {
  provisioning_dir = replace(
    abspath(path.root),
    "/.+?(live.*)/",
    "$1"
  )
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Owner            = "Terraform"
      Environment      = "dev"
      ProvisionFromDir = local.provisioning_dir
      Repository       = "https://github.com/tonyrud/terraform-learn.git"
    }
  }
}

data "aws_caller_identity" "current" {}

# ! NOTE: this uses the default security group alredy created by VPC module !
resource "aws_default_security_group" "default-sg" {
  vpc_id = module.vpc.vpc_id

  # open port 22 for ssh access from my IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip, "0.0.0.0/0"]
  }

  # open port 8080 for the app
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }
}

resource "aws_key_pair" "ssh-key" {
  key_name   = "${var.vpc_name}-server-key"
  public_key = file(var.public_key_location)
}

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
  for_each = { for each in var.ec2s : each.name => each }
  source   = "../../modules/ec2"

  public_subnets       = module.vpc.public_subnets
  default_sg           = aws_default_security_group.default-sg
  ssh_key_name         = aws_key_pair.ssh-key.key_name
  private_key_location = var.private_key_location

  # usage of tfvars list of objects
  instance_name    = each.value.name
  image            = each.value.image
  use_entry_script = each.value.use_entry_script
  install_docker   = each.value.install_docker
  volume_size      = each.value.volume_size
  instance_type    = each.value.instance_type
}

module "eks" {
  count           = var.create_k8s_cluster ? 1 : 0
  source          = "../../modules/eks"
  cluster_name    = "${var.vpc_name}-cluster"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
}