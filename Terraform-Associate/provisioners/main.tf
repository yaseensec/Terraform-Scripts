terraform {
  backend "remote" {
    organization = "Yaseenins"

    workspaces {
      name = "provisioners"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

data "aws_vpc" "main" {
  id = "vpc-blahblah"
}

resource "aws_security_group" "sg_vm1" {
  name        = "allow_tls"
  description = "My VM1 Security Group"
  vpc_id      = data.aws_vpc.main.id

  ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = [data.aws_vpc.main.cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["Public-IP/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  egress = [
    {
      description      = "Everything"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]
}

data "template_file" "user_data" {
  template = file("./cloud-init.yml")
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa <contents of .pub file email@example.com"
}
resource "aws_instance" "vm1" {
  ami                    = "ami-02e136e904f3da870"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.sg_vm1.id]
  user_data              = data.template_file.user_data.rendered
#   provisioner "local-exec" {
#       command = "echo ${self.private_ip} >> private_ip.txt"
    
#   }
#   provisioner "remote-exec" {
#       inline = [
#           "echo ${self.private_ip} >> /home/ec2-user/private_ip.txt"
#       ]
#       connection {
#         type = "ssh"
#         user = "ec2-user"
#         host = "$(self.public_ip)"
#         private_key = "${file("/home/.ssh/terraform")}"
#       }
#   }

    provisioner "file" {
        content     = "mars"
        destination = "/home/ec2-user/barsoon.txt"
		connection {
			type     = "ssh"
			user     = "ec2-user"
			host     = "${self.public_ip}"
			private_key = "${file("/root/.ssh/terraform")}"
		}
  }

  tags = {
    Name = "MyServer-vm1"
  }
}

output "public_ip" {
  value = aws_instance.vm1.public_ip
}