variable infra-env {
  type = string
  description = "infrastructure environment"
}

variable infra-role {
  type = string
  description = "infrastructure purpose"
  
}

variable instance-type {
  type = string
  description = "ec2 web server size"
  default = "t2.micro"
}

variable key-name {
  description = "EC2 Key-Pair"
}

variable instance-ami {
  type = string
  description = "server image to use"
}

variable instance-root-device-size {
  type = number
  description = "root block device size in GB"
  default = 12
}

variable subnets {
  type = list(string)
  description = "valid subnets to assign to server"
}

variable security-groups {
  type = list(string)
  description = "security groups to assign to server"
  default = []
}

variable tags {
  type = map(string)
  default = {}
  description = "tags for ec2 instance"
}

variable create-eip {
  type = bool
  default = false
  description = "Whether to create eip for ec2 or not"
}