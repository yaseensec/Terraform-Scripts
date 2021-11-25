terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}

variable "instance_type" {
  type = string
  description = "Instance Type"
  sensitive = true
  validation {
    condition     = can(regex("^t2.",var.instance_type))
    error_message = "The instance must be a t2 type EC2 instance."
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

locals {
  ami = "ami-02e136e904f3da870"
  instance_type ="var.instance_type"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "vm1" {
  ami           = local.ami
  instance_type = local.instance_type
}

output "public_ip" {
  value = aws_instance.vm1.public_ip
  description = "Public IP"
  sensitive = true
}

