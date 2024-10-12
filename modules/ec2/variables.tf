variable "instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
}

variable "volume_size" {
  description = "EBS volume size in GB"
  type        = number
}

variable "default_sg" {}
variable "instance_name" {}
variable "ssh_key_name" {}
variable "private_key_location" {}
variable "public_subnets" {}
variable "image" {}
variable "use_entry_script" {
  type    = bool
  default = false
}

variable "install_docker" {
  type    = bool
  default = false
}