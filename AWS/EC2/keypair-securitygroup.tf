provider "aws" {
    region = "ap-south-1"
    profile = "terraform-aws"
}

resource "aws_key_pair" "terraform-aws" {
  key_name   = "terraform-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1Z3VqX1ltmfT8OSYqC+brVNJogk8I0xv990oZ/t82pzo2QUOu5HU7TumpXFc2ICtWG42aiy4XUJfYAZhHcmT+ylXo/sYdY08ZnZiKsfzn40LfaLHZQdaD3xUVcCgwVciI+kWrOrRXPYMEXX/vIEEhMjuKoI9lXGXtj8EPV5jVn83FFpQCoPGhOZgGu9cAxpHGtX9VYnv2oK4rJdx0K3uXHefSA0B+hu6Dfx9KITYTGxRPVBVe0KVKnGClivYVJqj1FBxIxrLoOMpPsKDW4128Ucj0xh3GFgOyT2EFbjFQSwIh8Mh9cnyIjyn2ZY+CAT9stDntzOw2i9dCESCCkDxHeSE3agwwEnRLWM/SaNarWvxoT2J4rTP3yYMHkpq6jyPwz2cEoHh6xDm9dsEuqFna7kHVYkCmgNpLlhXFjCL6zYLz+7PNvgRDvltnCt0bvROX68HlEk4TjE3wl0a1esXMmGsN8N18PwLoTr9tQzK61X1S4kfCxDv8KzM6/YK8KCc= yaseen@DarkRose"
}

variable "vpc-default-id" {
  type = string
  default = "vpc-138fbc7b"
}

resource "aws_security_group" "terraform-ec2-sg" {
  name        = "terraform-ec2-sg"
  description = "Terraform-SG"
  vpc_id      = "${var.vpc-default-id}"

  ingress = [
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null

    }
  ]

  egress = [
    {
      description      = "ssh"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]
}

variable "ami-id" {
  default = "ami-04db49c0fb2215364"
}

resource "aws_instance" "terraform-ec2-instance" {
  ami           = "${var.ami-id}"
  instance_type = "t2.micro"
  key_name      = "terraform-key"
  vpc_security_group_ids = ["${aws_security_group.terraform-ec2-sg.id}"]


  tags = {
    Name = "Terraform-ec2"
  }
}