variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "private_subnet_cidr_blocks" {
  description = "Default value for private subnet CIDR blocks"
  type        = list(string)
}

variable "public_subnet_cidr_blocks" {
  description = "Default value for public subnet CIDR blocks"
  type        = list(string)
}

variable "my_ip" {}
variable "public_key_location" {}
variable "private_key_location" {
  description = "Location of the private key. This is only used for Ansible to make local exec calls"
  type        = string
}

variable "create_k8s_cluster" {
  type = bool
}

variable "ecr_names" {
  description = "Create ECR with these names"
  type        = list(string)
  default     = []
}

variable "ec2s" {
  type = list(object({
    name             = string
    image            = string
    use_entry_script = bool
  }))
}
