
locals {
  name   = var.instance_name

  tags = {
    Name       = local.name
  }
}

data "aws_ami" "image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = [var.image]
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
  ami           = data.aws_ami.image.id
  instance_type = var.instance_type

  iam_instance_profile = var.instance_profile

  subnet_id                = var.public_subnets[0]
  vpc_security_group_ids = [var.default_sg.id]
  availability_zone      = data.aws_availability_zones.available.names[0]

  root_block_device {
    volume_size = var.volume_size
  }

  associate_public_ip_address = true
  key_name                    = var.ssh_key_name

  user_data = var.use_entry_script ? file("../../scripts/entry-script.sh") : var.install_docker ? file("../../scripts/install_docker.sh") : null

  user_data_replace_on_change = var.use_entry_script || var.install_docker

  tags = local.tags

  # provison locally with ansible
  # turned off to test dynamic inventory in ansible repo
  # provisioner "local-exec" {
  #   working_dir = "/Users/tonyrudny/Developer/DevOps/techdegree-with-nana/15_ansible/playbooks"
  #   command = "ansible-playbook -i ${self.public_ip}, -u ec2-user --private-key ${var.private_key_location} docker.yaml"
  # }
}
