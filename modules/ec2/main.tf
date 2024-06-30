
variable "my_ip" {}

variable "ec2_instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
  default     = "t2.micro"
}

variable "public_key_location" {}
variable "vpc_id" {}

locals {
  name   = "${basename(path.cwd)}"

  tags = {
    Name       = local.name
  }
}

# ! NOTE: this uses the default security group alredy created by VPN module !
resource "aws_default_security_group" "default-sg" {
  vpc_id = var.vpc_id

  # open port 22 for ssh access from my IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  # open port 8080 for testing
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
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

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  filter {
    name   = "tag:Name"
    values = ["dev-private*"]
  }
}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  filter {
    name   = "tag:Name"
    values = ["dev-public*"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

output "public_ip" {
  value = aws_instance.app.public_ip
}

resource "aws_instance" "app" {
  ami           = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.ec2_instance_type

  subnet_id                = data.aws_subnets.public_subnets.ids[0]
  vpc_security_group_ids = [aws_default_security_group.default-sg.id]
  availability_zone      = data.aws_availability_zones.available.names[0]

  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh-key.key_name

  user_data = file("../../scripts/entry-script.sh")

  user_data_replace_on_change = true

  tags = local.tags
}

resource "aws_key_pair" "ssh-key" {
  key_name   = "server-key"
  public_key = file(var.public_key_location)
}
