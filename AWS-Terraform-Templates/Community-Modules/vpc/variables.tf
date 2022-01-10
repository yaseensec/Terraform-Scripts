variable infra-env {
  type = string
  description = "infrastructure environment"
}

variable vpc-cidr {
  type = string
  description = "Ip range to use for VPC"
  default = "10.0.0.0/16"
}

variable azs {
  type = list(string)
  description = "AZ's to create subnets into"
}

variable "public-subnets" {
  type = list(string)
  description = "Subnets to create for public network traffic,one per AZ"
}

variable "private-subnets" {
  type = list(string)
  description = "Subnets to create for private network traffic,one per AZ"
}

variable "database-subnets" {
  type = list(string)
  description = "Subnets to create for database traffic,one per AZ"
}