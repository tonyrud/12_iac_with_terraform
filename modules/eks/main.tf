locals {
  aws_k8s_role_mapping = [{
      rolearn = aws_iam_role.external-admin.arn
      username = "admin"
      groups = ["none"]
    },
    {
      rolearn = aws_iam_role.external-developer.arn
      username = "developer"
      groups = ["none"]
    }
  ]
}

#!! NOTE: If you create a load balancer, you will need to manually delete it in AWS Console !!
# This will then require you to manually delete the VPC as well
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name                             = var.cluster_name
  cluster_version                          = "1.30"
  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  create_cluster_security_group = false
  create_node_security_group    = false

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

# module "aws_auth" {
#   source = "terraform-aws-modules/eks/aws//modules/aws-auth"
#   create_aws_auth_configmap = true
#   manage_aws_auth_configmap = true
#   aws_auth_roles = local.aws_k8s_role_mapping
#   # aws_auth_users = var.eks_additional_users
# }

module "eks_aws_auth" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "~> 20.0"

  manage_aws_auth_configmap = true

  aws_auth_roles =   [{
      rolearn = aws_iam_role.external-admin.arn
      username = "admin"
      groups = ["none"]
    },
    {
      rolearn = aws_iam_role.external-developer.arn
      username = "developer"
      groups = ["none"]
    }
  ]

  # aws_auth_users = [
  #   {
  #     userarn  = "arn:aws:iam::66666666666:user/user1"
  #     username = "user1"
  #     groups   = ["custom-users-group"]
  #   },
  # ]
}