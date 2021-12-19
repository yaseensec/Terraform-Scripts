terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.69.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "ap-south-1"
}

module "Security-Group" {
  source = "./Security_Groups"

}

module "Load-Balancer" {
  source = "./Load_Balancer"
  publicsg-id = module.Security-Group.publicsgid-output
}

module "Key-Pair" {
  source = "./Key_Pair"
  
}

module "Auto-Scaling" {
  source = "./Auto_Scaling"
  privatesg-id = module.Security-Group.privatesgid-output
  tgarn = module.Load-Balancer.tgarn-output
  
}
