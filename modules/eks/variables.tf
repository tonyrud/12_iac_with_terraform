variable "cluster_name" {
  description = "Name for the Cluster"
  type        = string
}

variable "vpc_id" {}
variable "private_subnets" {}

# RBAC variables
variable user_for_admin_role {}
variable user_for_dev_role {}

# Argo CD variables
variable gitops_url {}
variable gitops_username {}
variable gitops_password {}

