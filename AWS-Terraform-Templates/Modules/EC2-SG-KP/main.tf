terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.69.0"
    }
  }
}

provider "aws" {
  region  = "ap-south-1"
  profile = "default"
}

module "EC2" {
    sg-id = module.Security-Group.sg-id-output
    key-pair = module.Key-Pair.key-pair-id-output
    source = "./EC2"
}

module "Key-Pair" {
    source = "./Key_Pair"
}

module "Security-Group" {
    source = "./Security_Group"
}
