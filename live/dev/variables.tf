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

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
}