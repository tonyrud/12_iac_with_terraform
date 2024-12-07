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

output "k8s_clusters" {
  description = "The name of the EKS cluster"

  value = [for s in module.eks : {
    cluster_name      = s.cluster_name
    configure_kubectl = s.configure_kubectl
    cluster_endpoint  = s.cluster_endpoint
  }]

}
