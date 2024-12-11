output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "ec2s" {
  description = "Name and Public IP of the instance"
  value = [for s in module.ec2 : {
    name      = s.name
    public_ip = s.public_ip
    ssh       = "ssh ubuntu@${s.public_ip}"
  }]
}

output "k8s_cluster" {
  description = "The name of the EKS cluster"

  value = {
    cluster_name      = module.eks.cluster_name
    configure_kubectl = module.eks.configure_kubectl
    cluster_endpoint  = module.eks.cluster_endpoint
  }
}
