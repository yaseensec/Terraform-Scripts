variable "amiid" {
  default = "ami-0851b76e8b1bce90b"
}

module "Shared-Vars" {
  source = "../Shared_Vars"
  
}

variable "sg-id" {}
variable "key-pair" {}

resource "aws_instance" "terraform-ec2" {
  ami           = var.amiid
  instance_type = "t2.nano"

  key_name = var.key-pair
  vpc_security_group_ids = [ var.sg-id ]

  tags = {
    Name = "EC2-Name-${module.Shared-Vars.env-suffix-output}"
  }
  
}

