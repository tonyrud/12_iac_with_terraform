module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name                             = "myapp-eks-cluster"
  cluster_version                          = "1.30"
  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  subnet_ids = module.vpc.private_subnets
  vpc_id     = module.vpc.vpc_id

  eks_managed_node_groups = {
    # ec2 name will be the key value
    dev = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t2.small"]
      # capacity_type  = "SPOT"
    }
  }

  tags = {
    environment = "dev"
    application = "myapp"
  }
}