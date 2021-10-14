module "shared_vars" {
    source = "../shared_vars"
}

variable privatesg_id {}
variable tg_arn {}

output "amiid" {
    value = "${local.amiid}"
}

output "instancetype" {
    value = "${local.instancetype}"
}

output "keypairname" {
    value = "${local.keypairname}"
}

locals {
    env = "${terraform.workspace}"
    amiid_env = {
        default = "ami-04db49c0fb2215364"
        staging = "ami-04db49c0fb2215364"
        production = "ami-04db49c0fb2215364"
    }

    amiid = "${lookup(local.amiid_env, local.env)}"

    instancetype_env = {
        default = "t2.micro"
        staging = "t2.micro"
        production = "t2.micro"
    }

    instancetype = "${lookup(local.instancetype_env, local.env)}"

    keypairname_env = {
        default = "terraform-key"
        staging = "terraform-key"
        production = "terraform-key"
    }

    keypairname = "${lookup(local.keypairname_env, local.env)}"

    asgdesired_env = {
        default = "1"
        staging = "1"
        production = "2"
    }

    asgdesired = "${lookup(local.asgdesired_env, local.env)}"

    asgmin_env = {
        default = "1"
        staging = "1"
        production = "2"
    }

    asgmin = "${lookup(local.asgmin_env, local.env)}"

    asgmax_env = {
        default = "2"
        staging = "2"
        production = "4"
    }

    asgmax = "${lookup(local.asgmin_env, local.env)}"
}

resource "aws_launch_configuration" "sampleapp_lc" {
  name          = "sampleapp-lc-${local.env}"
  image_id      = "${local.amiid}"
  instance_type = "${local.instancetype}"
  key_name = "${local.keypairname}"
  user_data = "${file("assets/userdata.txt")}"
  security_groups = ["${var.privatesg_id}"]
}

resource "aws_autoscaling_group" "sampleapp_asg" {
  name                      = "sampleapp-asg-${module.shared_vars.env_suffix}"
  max_size                  = "${local.asgmax}"
  min_size                  = "${local.asgmin}"
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = "${local.asgdesired}"
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.sampleapp_lc.name}"
  vpc_zone_identifier       = ["${module.shared_vars.publicsubnetid1}"]
  target_group_arns = ["${var.tg_arn}"]

  tag {
    key                 = "Name"
    value               = "Sampleapp_${module.shared_vars.env_suffix}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "${module.shared_vars.env_suffix}"
    propagate_at_launch = true
  }
}