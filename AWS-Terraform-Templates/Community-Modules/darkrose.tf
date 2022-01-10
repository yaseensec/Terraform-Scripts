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

locals {
  infra-env = terraform.workspace
}

variable "default-region" {
  type        = string
  description = "the region this infrastructure is in"
  default     = "ap-south-1"
}

variable db-user {
  type = string
  description = "the database user"
}

variable db-pass {
  type = string
  description = "the database password"
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
  source                    = "./ec2"
  infra-env                 = local.infra-env
  infra-role                = "web"
  instance-type             = "t2.micro"
  instance-ami              = data.aws_ami.darkrose-ami.id
  instance-root-device-size = 12
  subnets                   = module.VPC.vpc-public-subnets-output
  security-groups           = [module.VPC.security-group-public-output]
  key-name                  = module.VPC.keypair-web-key-output

  tags = {
    Name = "darkrose-${local.infra-env}-web"
  }

  create-eip = true
}

module "EC2-Worker" {
  source                    = "./ec2"
  infra-env                 = local.infra-env
  infra-role                = "worker"
  instance-type             = "t2.large"
  instance-ami              = data.aws_ami.darkrose-ami.id
  instance-root-device-size = 16
  subnets                   = module.VPC.vpc-private-subnets-output
  security-groups           = [module.VPC.security-group-private-output]
  key-name                  = module.VPC.keypair-worker-key-output

  tags = {
    Name = "darkrose-${local.infra-env}-worker"
  }

  create-eip = false
}

module "VPC" {
  source    = "./vpc"
  infra-env = local.infra-env
  vpc-cidr  = "10.0.0.0/17"
  azs = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  public-subnets = slice(cidrsubnets("10.0.0.0/17", 4, 4, 4, 4, 4, 4, 4, 4, 4), 0, 3)
  private-subnets = slice(cidrsubnets("10.0.0.0/17", 4, 4, 4, 4, 4, 4, 4, 4, 4), 3, 6)
  database-subnets = slice(cidrsubnets("10.0.0.0/17", 4, 4, 4, 4, 4, 4, 4, 4, 4), 6, 9)
}

module "RDS" {
  source = "./rds"

  infra-env = local.infra-env
  instance-type = "db.t3.medium"
  subnets = module.VPC.vpc-database-subnets-output
  vpc-id = module.VPC.vpc-id-output
  master-username = var.db-user
  master-password = var.db-pass
  name = "darkroseauroradatabase"
}