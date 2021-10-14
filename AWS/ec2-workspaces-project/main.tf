provider "aws" {
    region = "ap-south-1"
    profile = "terraform-aws"
}

module "sg-module" {
    source = "./sg-module"
}

module "ec2-module-1" {
    sg-id = "${module.sg-module.sg-id-output}"
    source = "./ec2-module"
}

locals {
    env = "${terraform.workspace}"

    ami-id-env{
        default = "ami-id-default"
        stagging = "ami-id-stagging"
        production = "ami-id-production"
    }
    ami-id = "${lookup(local.ami-id-env, local.env)}"
}

output "envspecific-output-variable" {
    value = "${local.ami-id}"
}
