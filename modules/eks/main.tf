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
}

# requires helm provider
module "eks_blueprints_addons" {
  source = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.0" #ensure to update this to the latest/desired version
  
  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  enable_aws_load_balancer_controller    = true
  enable_metrics_server                  = true
  enable_cluster_autoscaler              = true
  cluster_autoscaler = {
    set = [
      {
        name = "extraArgs.scale-down-unneeded-time"
        value = "1m"
      },
      {
        name = "extraArgs.skip-nodes-with-local-storage"
        value = false
      },
      {
        name = "extraArgs.skip-nodes-with-system-pods"
        value = false
      }
    ]
  }

  # enable_argocd                        = true
  # enable_argo_rollouts                 = true

  # argocd = {
  #   values = [
  #     yamlencode({
  #       server = {
  #         service = {
  #           annotations = {
  #             "service.beta.kubernetes.io/aws-load-balancer-name" = "argocd"
  #             "service.beta.kubernetes.io/aws-load-balancer-type" = "external"
  #             "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type" = "ip"
  #             "service.beta.kubernetes.io/aws-load-balancer-scheme"="internet-facing"
  #           },
  #           type = "LoadBalancer"
  #         }
  #       }
  #     })
  #   ]
  # }

}