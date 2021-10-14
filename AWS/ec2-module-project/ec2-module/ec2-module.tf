
variable "vpc-default-id" {
  type = string
  default = "vpc-138fbc7b"
}

resource "aws_security_group" "terraform-ec2-sg1" {
  name        = "terraform-ec2-sg1"
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
  vpc_security_group_ids = ["${aws_security_group.terraform-ec2-sg1.id}"]


  tags = {
    Name = "Terraform-ec2"
  }
}
