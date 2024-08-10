output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "ec2_public_ips" {
  description = "Name and Public IP of the instance"
  value = [for s in module.ec2 : "${s.name} - ${s.public_ip}"]  
}