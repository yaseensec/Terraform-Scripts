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

resource "aws_s3_bucket" "bucket" {
  bucket = "yaseenins-bucket"
  acl    = "private"

  tags = {
    Name        = "terraform-bucket"
    Environment = "DEV"
  }
}

resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.bucket.id
  key    = "testfile.txt"
  source = "./test.txt"
  etag   = filemd5("./test.txt")

}
