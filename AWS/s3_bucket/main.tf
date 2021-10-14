provider "aws" {
    region = "ap-south-1"
    profile = "terraform-aws"
}

resource "aws_s3_bucket" "bucketreferncename" {
  bucket = "bucket-name-to-create"
  acl    = "private"

  tags = {
    Name        = "my test bucket"
    Environment = "Test"
  }
}

resource "aws_s3_bucket_object" "myfirstobject" {
  bucket = "${aws_s3_bucket.bucketreferncename.id}"
  key    = "testfile1.txt"
  source = "./test.txt"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("./test.txt")
}