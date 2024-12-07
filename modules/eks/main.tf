#!! NOTE: If you create a load balancer, you will need to manually delete it in AWS Console !!
# This will then require you to manually delete the VPC as well
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name                             = var.cluster_name
  cluster_version                          = "1.30"
  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  subnet_ids = var.private_subnets
  vpc_id     = var.vpc_id

  cluster_addons = {
    kube-proxy = {}
    vpc-cni    = {}
    coredns = {}
  }

  eks_managed_node_groups = {
    # ec2 name will be this key value
    initial = {
      min_size     = 2
      max_size     = 2
      desired_size = 2

      instance_types = ["t2.micro"]
    }
  }
}