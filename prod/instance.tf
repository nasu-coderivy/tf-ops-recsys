module "tags" {
  source = "git@github.com:coderivy-ai/tf-module-tags.git//module?ref=0.0.3"

  environment = "prod"

  name = "recsys"
  resource_identifier = "ec2"
  product = "infra"
}

resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id         = var.subnet_id
  availability_zone = local.recsys_az

  # security group
  vpc_security_group_ids = [aws_security_group.recsys-allow-ssh.id]

  # public SSH key
  key_name = aws_key_pair.recsys-keypair.key_name

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = merge(module.tags.tags, { Name = "Recsys" })
}

resource "aws_security_group" "recsys-allow-ssh" {
  vpc_id      = var.vpc_id
  name        = "recsys-allow-ssh"
  description = "security group that allows ssh and all egress traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(module.tags.tags, { Name = "recsys-allow-ssh" })
}

resource "aws_key_pair" "recsys-keypair" {
  key_name   = "recsys-keypair"
  public_key = file(var.path_to_public_key)
}
