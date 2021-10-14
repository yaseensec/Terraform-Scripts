provider "aws" {
    region = "ap-south-1"
    profile = "terraform-aws"
}

module "ec2_module" {
    source = "./ec2-module"
}