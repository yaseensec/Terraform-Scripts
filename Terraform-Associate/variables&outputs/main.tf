terraform {
  
}

module "output_chaining" {
    source = ".//output_chaining"
    instance_type = "t2.micro"
  
}

output "public_ip" {
  value = module.output_chaining.public_ip
  description = "Public IP"
  sensitive = true
}

