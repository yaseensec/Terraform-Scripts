variable "vpc_id" {
    type = string
  
}
variable "bucket" {
    type = string
    default = "<randomnum>"
  
}
variable "my_ip_with_cidr" {
    type = string
    description = "My Home Machine IP eg:publicip/32"
}

variable "public_key" {
    type = string
  
}

variable "instance_type" {
    type = string
}

variable "server_name" {
    type = string
}