resource "aws_security_group" "elb_app" {
  name = "${format("%s-elb-app-sg", var.name)}"

  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = "${var.app_port}"
    to_port     = "${var.app_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Group : "${var.name}"
  }

}

resource "aws_elb" "elb-app" {
  name            = "${format("%s-elb-app", var.name)}"
  subnets         = "${var.vpc_private_subnets}"
  security_groups = ["${aws_security_group.elb_app.id}"]
  internal        = true

  listener {
    instance_port     = "${var.app_port}"
    instance_protocol = "http"
    lb_port           = "${var.app_port}"
    lb_protocol       = "http"
  }

  health_check {
      target              = "HTTP:${var.app_port}/"
      interval            = "${var.app_elb_health_check_interval}"
      healthy_threshold   = "${var.app_elb_healthy_threshold}"
      unhealthy_threshold = "${var.app_elb_unhealthy_threshold}"
      timeout             = "${var.app_elb_health_check_timeout}"
      #interval            = 20
      #healthy_threshold   = 2
      #unhealthy_threshold = 2
      #timeout             = 5
  }

  tags = {
    "Terraform" : "true"
  }
}

