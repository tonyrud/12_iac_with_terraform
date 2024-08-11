
locals {
  name   = var.instance_name

  tags = {
    Name       = local.name
  }
}

data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "latest-ubuntu-image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_instance" "app" {
  # TODO: if/else for AMI
  ami           = data.aws_ami.latest-ubuntu-image.id
  # ami           = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.ec2_instance_type

  subnet_id                = var.public_subnets[0]
  vpc_security_group_ids = [var.default_sg.id]
  availability_zone      = data.aws_availability_zones.available.names[0]

  associate_public_ip_address = true
  key_name                    = var.ssh_key_name

  user_data = file("../../scripts/entry-script.sh")

  user_data_replace_on_change = true

  tags = local.tags
}
