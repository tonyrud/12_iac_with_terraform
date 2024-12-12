# Kubectl Configuration
output "configure_kubectl" {
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value = "aws eks update-kubeconfig --name ${module.eks.cluster_name}"
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value = module.eks.cluster_endpoint
}