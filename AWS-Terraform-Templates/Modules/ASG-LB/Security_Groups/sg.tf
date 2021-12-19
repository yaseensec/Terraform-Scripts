module "Shared-Vars" {
  source = "../Shared_Vars"
}
resource "aws_security_group" "public-sg" {
  name = "PublicSG-${module.Shared-Vars.envsuffix-output}"
  description = "Terraform-EC2-PublicSG"
  vpc_id = module.Shared-Vars.vpcid-output

  ingress {
    description      = "WEB"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  egress {
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web"
  }
}

output "publicsgid-output" {
  value = aws_security_group.public-sg.id
}

resource "aws_security_group" "private-sg" {
  name = "PrivateSG-${module.Shared-Vars.envsuffix-output}"
  description = "Terraform-EC2-PrivateSG"
  vpc_id = module.Shared-Vars.vpcid-output

  ingress {
    description      = "WEB"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = [ aws_security_group.public-sg.id ]
  }

  egress {
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web"
  }
}

output "privatesgid-output" {
  value = aws_security_group.private-sg.id
}