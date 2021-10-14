
variable "ami-id" {
  default = "ami-04db49c0fb2215364"
}

module "shared-vars"{
  source = "../shared-vars"
}

variable "sg-id" {}


resource "aws_instance" "terraform-ec2-instance" {
  ami           = "${var.ami-id}"
  instance_type = "t2.micro"
  key_name      = "terraform-key"
  vpc_security_group_ids = ["${var.sg-id}"]


  tags = {
    Name = "EC2-Name-Instance-${module.shared-vars.env-suffix}"
  }
}
