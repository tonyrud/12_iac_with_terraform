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

variable "my_ip" {
  description = "My IP address"
  type        = string
}

variable "public_key" {
  description = "Public key for SSH access"
  type        = string
}

variable "create_k8s_cluster" {
  type    = bool
  default = false
}

variable "ecr_names" {
  description = "Create ECR with these names"
  type        = list(string)
  default     = []
}

variable "ec2s" {
  type = list(object({
    name          = string
    image         = string
    instance_type = optional(string, "t2.micro")
    volume_size   = optional(number, 8)
    entry_script  = optional(string, "")
  }))
}

variable "user_for_admin_role" {}
variable "user_for_dev_role" {}

