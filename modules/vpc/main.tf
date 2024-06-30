data "aws_availability_zones" "azs" {
  state = "available"
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