terraform {

}

provider "aws" {
  profile = "default"
  region = "us-east-1"
}

module "apache" {
	source = ".//apache-module"
	vpc_id = "vpc-blahblah"
	my_ip_with_cidr = "publicip/32"
	public_key = "ssh-rsa <ssh-key>"
	instance_type = "t2.micro"
 	server_name = "Apache Example Server"
}

output "public_ip" {
  value = module.apache.public_ip
}
