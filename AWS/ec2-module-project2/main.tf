provider "aws" {
    region = "ap-south-1"
    profile = "terraform-aws"
}

module "sg-module" {
    source = "./sg-module"
}

module "ec2-module-1" {
    sg-id = "${module.sg-module.sg-id-output}"
    ec2-name = "EC2 instance 2 from module"
    source = "./ec2-module"
}

module "ec2-module-2" {
    sg-id = "${module.sg-module.sg-id-output}"
    ec2-name = "EC2 instance 2 from module"
    source = "./ec2-module"
}