
variable "ami-id" {
  default = "ami-04db49c0fb2215364"
}

variable "sg-id" {}
variable "ec2-name" {}


resource "aws_instance" "terraform-ec2-instance" {
  ami           = "${var.ami-id}"
  instance_type = "t2.micro"
  key_name      = "terraform-key"
  vpc_security_group_ids = ["${var.sg-id}"]


  tags = {
    Name = "${var.ec2-name}"
  }
}
