module "Shared-Vars" {
    source = "../Shared_Vars"
}

variable "privatesg-id" {}
variable "tgarn" {
  
}

output "amiid" {
    value = local.amiid
}

output "instancetype" {
    value = local.instancetype
}

output "keypair" {
    value = local.keypair
}

locals {

  env = terraform.workspace

  amiid_env = {
      default    = "ami-052cef05d01020f1d"
      staging    = "ami-052cef05d01020f1d"
      production = "ami-0002bdad91f793433"
  }

  amiid = "${lookup(local.amiid_env, local.env)}"

  instancetype_env = {
      default    = "t2.micro"
      staging    = "t2.micro"
      production = "t2.medium"
  }

  instancetype = "${lookup(local.instancetype_env, local.env)}"

  keypair_env = {
      default    = "staging-key"
      staging    = "staging-key"
      production = "production-key"
  }

  keypair = "${lookup(local.keypair_env, local.env)}"

  asgdesired_env = {
      default    = "1"
      staging    = "1"
      production = "2"
  }

  asgdesired = "${lookup(local.asgdesired_env, local.env)}"

  asgmin_env = {
      default    = "1"
      staging    = "1"
      production = "2"
  }

  asgmin = "${lookup(local.asgmin_env, local.env)}"

  asgmax_env = {
      default    = "2"
      staging    = "2"
      production = "4"
  }

  asgmax = "${lookup(local.asgmax_env, local.env)}"
}

resource "aws_launch_configuration" "Launch-Config-applb" {
  name          = "Launch-Config-applb-${module.Shared-Vars.envsuffix-output}"
  image_id      = local.amiid
  instance_type = local.instancetype
  key_name      = local.keypair
  user_data = file("./Assets/userdata.txt")
  security_groups = [ var.privatesg-id ]
}

resource "aws_autoscaling_group" "applb-asg" {
  name                      = "applb-asg${module.Shared-Vars.envsuffix-output}"
  max_size                  = local.asgmax
  min_size                  = local.asgmin
  desired_capacity          = local.asgdesired
  launch_configuration      = aws_launch_configuration.Launch-Config-applb.name
  vpc_zone_identifier       = [module.Shared-Vars.publicsubnetid1-output]
  target_group_arns = [ var.tgarn]
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "App-${module.Shared-Vars.envsuffix-output}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "App-${module.Shared-Vars.envsuffix-output}"
    propagate_at_launch = true
  }
}
