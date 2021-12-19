terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.69.0"
    }
  }
}

provider "aws" {
  region  = "ap-south-1"
  profile = "default"
}

variable "vpcid" {
  type = string
  default = "vpc-138fbc7b" 
}

resource "aws_key_pair" "terraform-key" {
  key_name = "terraform-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFXxYaH6QyTnn+8vgNNnksQ8sLX5YePIFOR4ODt9zObY yaseen@DarkRose"
}

resource "aws_security_group" "ec2-sg" {
  name = "terraform-ec-sg"
  description = "Terraform-EC2-SG"
  vpc_id = var.vpcid

  ingress {
    description      = "SSh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

variable "amiid" {
  default = "ami-0851b76e8b1bce90b"
}

resource "aws_instance" "terraform-ec2" {
  ami           = var.amiid
  instance_type = "t2.nano"

  key_name = aws_key_pair.terraform-key.id
  vpc_security_group_ids = [ aws_security_group.ec2-sg.id ]

  tags = {
    Name = "terraform-ec2-instance"
  }
}

