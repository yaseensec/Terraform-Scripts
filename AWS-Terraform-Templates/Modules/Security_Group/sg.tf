variable "vpcid" {
  type = string
  default = "vpc-138fbc7b"
}

module "Shared-Vars" {
  source = "../Shared_Vars"
}
resource "aws_security_group" "ec2-sg" {
  name = "SG-Name-${module.Shared-Vars.env-suffix-output}"
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

output "sg-id-output" {
  value = aws_security_group.ec2-sg.id
}