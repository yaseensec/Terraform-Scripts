terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "43802482094298-depends-on"
}

resource "aws_instance" "vm1" {
  ami           = "ami-02e136e904f3da870"
  instance_type = "t2.micro"
  depends_on = [
		aws_s3_bucket.bucket
	]

}

output "public_ip" {
  value = aws_instance.vm1.public_ip
  description = "Public IP"
  sensitive = true
}

