variable infra-env {
  type = string
  description = "infrastructure environment"
  
}

variable vpc-cidr {
  type = string
  description = "Ip range to use for VPC"
  default = "10.0.0.0/16"
}

variable "public-subnet-numbers" {
  type = map(number)
  description = "Map of AZ to a number that should be used for Public Subnets"
  default = {
    "ap-south-1a" = 1
    "ap-south-1b" = 2
    "ap-south-1c" = 3
  }
}

variable "private-subnet-numbers" {
  type = map(number)
  description = "Map of AZ to a number that should be used for Private Subnets"
  default = {
    "ap-south-1a" = 4
    "ap-south-1b" = 5
    "ap-south-1c" = 6
  }
}