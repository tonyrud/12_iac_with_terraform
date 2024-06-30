# WIP

# locals {
#   name   = "${basename(path.cwd)}"
#   # region = var.aws_region

#   vpc_cidr = "10.0.0.0/16"
#   azs      = slice(data.aws_availability_zones.available.names, 0, 3)

#   user_data = <<-EOT
#     #!/bin/bash
#     echo "Hello Terraform!"
#   EOT

#   tags = {
#     CreatedBy = "Terraform"
#     Name       = local.name
#     Repository = "https://github.com/tonyrud/terraform-learn.git"
#   }
# }

# data "aws_ami" "latest-amazon-linux-image" {
#   most_recent = true
#   owners      = ["amazon"]
#   filter {
#     name   = "name"
#     values = ["amzn2-ami-kernel-*-x86_64-gp2"]
#   }
#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }

# output "aws_ami_id" {
#   value = data.aws_ami.latest-amazon-linux-image
# }

# module "security_group" {
#   source  = "terraform-aws-modules/security-group/aws"
#   version = "~> 4.0"

#   name        = local.name
#   description = "Security group for example usage with EC2 instance"
#   vpc_id      = module.vpc.vpc_id

#   ingress_cidr_blocks = ["0.0.0.0/0"]
#   ingress_rules       = ["http-80-tcp", "all-icmp"]
#   egress_rules        = ["all-all"]

#   tags = local.tags
# }

# module "ec2_instance" {
#   source  = "terraform-aws-modules/ec2-instance/aws"

#   name = "single-instance"

#   ami                         = data.aws_ami.latest-amazon-linux-image.id
#   instance_type               = "t2.micro"
#   availability_zone           = element(module.vpc.azs, 0)
#   subnet_id                   = element(module.vpc.private_subnets, 0)

#   key_name               = "user1"
#   monitoring             = true
#   vpc_security_group_ids      = [module.security_group.security_group_id]

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }
