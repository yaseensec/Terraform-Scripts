provider "aws" {
    region = ap-south-1
    profile = "terraform-aws"
}

//string variable

variable "firststringname" {
    type = string
    default = "this is my first string"
}

variable "multilinestringname" {
    type = string
    default = <<-EOH
    this is my first string
    2nd
    3rd
    EOH
}

variable "mapsexamplename" {
    type = map
    default = {
        "apsouth" = "ami-1"
        "useast" = "ami-2"
    }
}

variable "listexamplename" {
    type = list
    default = ["sg1", "sg2", "sg3"]
}

variable "booleanexamplename" {
    default = false
}

output "myfirstoutput" {
    value = "${var.firststringname}"
}

output "mymultilineoutput" {
    value = "${var.multilinestringname}"
}

output "mapoutput" {
    value = "${var.mapsexamplename["useast"]}"
}

output "listoutput" {
    value = "${var.listexamplename}"
}

output "booloutput" {
    value = "${var.booleanexamplename}"
}

variable "myinputvariable" {
    type = string
}

output "myoutputvariable" {
    sensitive = true
    value = "${var.myinputvariable}"
}