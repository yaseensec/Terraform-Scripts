variable publicsg_id {}

module "shared_vars" {
    source = "../shared_vars"
}



resource "aws_lb" "sampleapp_alb" {
  name               = "sampleapp-alb-${module.shared_vars.env_suffix}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${var.publicsg_id}"]
  subnets            = ["${module.shared_vars.publicsubnetid1}","${module.shared_vars.publicsubnetid2}"]

  enable_deletion_protection = true

  tags = {
    Environment = "${module.shared_vars.env_suffix}"
  }
}

resource "aws_lb_target_group" "sampleapp_http_tg" {
  name     = "sampleapp-http-tg-${module.shared_vars.env_suffix}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${module.shared_vars.vpcid}"
  health_check {
    path = "/icons/apache_pb2.gif"
    interval = 5
    timeout = 4
    healthy_threshold = 2
    unhealthy_threshold = 10
  }
}

output "tg_arn" {
  value = "${aws_lb_target_group.sampleapp_http_tg.arn}"
}

resource "aws_lb_listener" "http_listener_80" {
  load_balancer_arn = "${aws_lb.sampleapp_alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.sampleapp_http_tg.arn}"
  }
}