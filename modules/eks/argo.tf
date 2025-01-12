provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    token                  = data.aws_eks_cluster_auth.this.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name",  module.eks.cluster_name]
    }
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "6.4.0"
  namespace        = "argocd"
  create_namespace = true
  depends_on       = [
    module.eks
  ]
}

resource "kubernetes_secret" "argocd_gitops_repo" {
  depends_on = [
    helm_release.argocd
  ]

  metadata {
    name = "gitops-k8s-repo"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    type: "git"
    url: var.gitops_url
    username: var.gitops_username
    password: var.gitops_password
  }

  type = "Opaque"
}
