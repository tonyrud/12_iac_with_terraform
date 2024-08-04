data "aws_availability_zones" "azs" {
  state = "available"
}

# terraform state show module.vpc.data.aws_subnets.private_subnets
data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }

  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name}-private*"]
  }
}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }

  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name}-public*"]
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.0"

  name = var.vpc_name
  cidr = var.vpc_cidr
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets  = var.public_subnet_cidr_blocks


  azs = data.aws_availability_zones.azs.names

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernets.io/cluster/myapp-eks-cluster" = "shared"
    "terraform"                              = "true"
  }

  public_subnet_tags = {
    "kubernets.io/cluster/myapp-eks-cluster" = "shared"
    "kubernets.io/role/elb"                  = 1
  }

  private_subnet_tags = {
    "kubernets.io/cluster/myapp-eks-cluster" = "shared"
    "kubernets.io/role/internal-elb"         = 1
  }
}