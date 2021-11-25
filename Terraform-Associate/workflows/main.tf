terraform {

}

provider "aws" {
  profile = "default"
  region = "us-east-1"
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket
}

module "apache" {
	source = ".//apache-module"
	vpc_id = var.vpc_id
	my_ip_with_cidr = var.my_ip_with_cidr
	public_key = var.public_key
	instance_type = var.instance_type
 	server_name = var.server_name
}

output "public_ip" {
  value = module.apache.public_ip
}
