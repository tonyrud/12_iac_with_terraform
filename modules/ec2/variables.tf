variable "my_ip" {}

variable "ec2_instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
  default     = "t2.micro"
}

variable "public_key_location" {}
variable "vpc_id" {}
variable "public_subnets" {}
