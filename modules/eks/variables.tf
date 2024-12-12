variable "cluster_name" {
  description = "Name for the Cluster"
  type        = string
}

variable "vpc_id" {}
variable "private_subnets" {}

variable user_for_admin_role {}
variable user_for_dev_role {}
