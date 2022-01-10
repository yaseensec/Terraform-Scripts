variable "infra-env" {
  description = "The infrastructure environment."
}

variable "instance-type" {
  description = "RDS instance type and size"
}

variable "subnets" {
  type        = list(string)
  description = "A list of subnets to join"
}

variable "vpc-id" {
  description = "The VPC to create the Aurora cluster within"
}

variable "master-username" {
  description = "The master username of the Aurora cluster"
}

variable "master-password" {
  description = "The master password of the Aurora cluster"
}

variable "name" {
  description = "Name used across resources created"
  type        = string
  default     = ""
}
