data "aws_vpc" "main" {
  id = var.vpc_id
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
      cidr_blocks      = ["var.my_ip_with_cidr"]
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

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.public_key
}

data "template_file" "user_data" {
  template = file("${abspath(path.module)}/cloud-init.yml")
}

data "aws_ami" "amazon-linux-2" {
 	most_recent = true
	owners = ["amazon"]
	filter {
		name   = "owner-alias"
		values = ["amazon"]
	}
	filter {
		name   = "name"
		values = ["amzn2-ami-hvm*"]
	}
}
resource "aws_instance" "vm1" {
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.sg_vm1.id]
  user_data              = data.template_file.user_data.rendered

  tags = {
    Name = var.server_name
}

}