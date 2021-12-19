terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.69.0"
    }
  }
}

provider "aws" {
  profile = "darkrose"
  region  = var.default-region
}

variable "infra-env" {
  type        = string
  description = "infrastructure environment"

}

variable "default-region" {
  type        = string
  description = "the region this infrastructure is in"
  default     = "ap-south-1"
}

data "aws_ami" "darkrose-ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["099720109477"] #Canonical Official
}

module "EC2-Web" {
  source                    = "./modules/ec2"
  infra-env                 = var.infra-env
  infra-role                = "web"
  instance-type             = "t2.micro"
  instance-ami              = data.aws_ami.darkrose-ami.id
  instance-root-device-size = 12
  subnets                   = keys(module.VPC.vpc-public-subnets-output)
  security-groups           = [module.VPC.security-group-public-output]
  key-name                  = module.VPC.keypair-web-key-output

  tags = {
    Name = "darkrose-${var.infra-env}-web"
  }

  create-eip = true
}

module "EC2-Worker" {
  source                    = "./modules/ec2"
  infra-env                 = var.infra-env
  infra-role                = "worker"
  instance-type             = "t2.large"
  instance-ami              = data.aws_ami.darkrose-ami.id
  instance-root-device-size = 16
  subnets                   = keys(module.VPC.vpc-private-subnets-output)
  security-groups           = [module.VPC.security-group-private-output]
  key-name                  = module.VPC.keypair-worker-key-output

  tags = {
    Name = "darkrose-${var.infra-env}-worker"
  }

  create-eip = false
}

module "VPC" {
  source    = "./modules/vpc"
  infra-env = var.infra-env
  vpc-cidr  = "10.0.0.0/17"
}