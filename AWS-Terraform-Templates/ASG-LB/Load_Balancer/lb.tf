module "Shared-Vars" {
    source = "../Shared_Vars"
}

variable "publicsg-id" {}
output "tgarn-output" {
  value = aws_lb_target_group.applb-targetgroup.arn
}

resource "aws_lb" "applb" {
  name               = "applb-${module.Shared-Vars.envsuffix-output}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.publicsg-id]
  subnets            = [module.Shared-Vars.publicsubnetid1-output,module.Shared-Vars.publicsubnetid2-output]

  enable_deletion_protection = true

  tags = {
    Environment = module.Shared-Vars.envsuffix-output
  }
}

resource "aws_lb_target_group" "applb-targetgroup" {
  name     = "applb-targetgroup-${module.Shared-Vars.envsuffix-output}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.Shared-Vars.vpcid-output
  health_check {
    path = "/icons/apache_pb2.gif"
    interval = 5
    timeout = 4
    healthy_threshold = 2
    unhealthy_threshold = 10
  }
}

resource "aws_lb_listener" "http-listener-80" {
  load_balancer_arn = aws_lb.applb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.applb-targetgroup.arn
  }
}