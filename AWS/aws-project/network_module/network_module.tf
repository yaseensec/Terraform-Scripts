module "shared_vars" {
    source = "../shared_vars"
}

resource "aws_security_group" "publicsg" {
    name = "publicsg_${module.shared_vars.env_suffix}"
    description = "publicsg for ELB ${module.shared_vars.env_suffix}"
    vpc_id = "${module.shared_vars.vpcid}"

    ingress = [
    {
      description      = "WEB"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  egress = [
    {
      description      = "WEB"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]
}

output "publicsg_id" {
    value = "${aws_security_group.publicsg.id}"
}

resource "aws_security_group" "privatesg" {
    name = "privatesg_${module.shared_vars.env_suffix}"
    description = "privatesg for EC2 ${module.shared_vars.env_suffix}"
    vpc_id = "${module.shared_vars.vpcid}"

    ingress = [
    {
      description      = "WEB"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = null
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = ["${aws_security_group.publicsg.id}"]
      self             = null
    }
  ]

  egress = [
    {
      description      = "WEB"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]
}

output "privatesg_id" {
    value = "${aws_security_group.privatesg.id}"
}