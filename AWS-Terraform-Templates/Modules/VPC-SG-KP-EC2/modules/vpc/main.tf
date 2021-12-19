resource "aws_vpc" "darkrose-vpc" {
  cidr_block = var.vpc-cidr

  tags = {
    Name        = "darkrose-${var.infra-env}-web"
    Project     = "Darkrose.io"
    Environment = var.infra-env
    ManagedBy   = "terraform"
  }
}

resource "aws_subnet" "public-subnet" {
  for_each = var.public-subnet-numbers

  vpc_id = aws_vpc.darkrose-vpc.id

  cidr_block = cidrsubnet(aws_vpc.darkrose-vpc.cidr_block, 4, each.value)

  tags = {
    Name        = "darkrose-${var.infra-env}-public-subnet"
    Role        = "Public-Subnet"
    Project     = "Darkrose.io"
    Environment = var.infra-env
    ManagedBy   = "terraform"
    Subnet      = "${each.key}-${each.value}"
  }
}

resource "aws_subnet" "private-subnet" {
  for_each = var.private-subnet-numbers

  vpc_id = aws_vpc.darkrose-vpc.id

  cidr_block = cidrsubnet(aws_vpc.darkrose-vpc.cidr_block, 4, each.value)

  tags = {
    Name        = "darkrose-${var.infra-env}-private-subnet"
    Role        = "Private-Subnet"
    Project     = "Darkrose.io"
    Environment = var.infra-env
    ManagedBy   = "terraform"
    Subnet      = "${each.key}-${each.value}"
  }
}