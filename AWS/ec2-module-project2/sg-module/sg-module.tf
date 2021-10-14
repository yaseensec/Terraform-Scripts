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

output "sg-id-output" {
    value = "${aws_security_group.terraform-ec2-sg1.id}"
}