resource "aws_security_group" "elb_web" {
  name = "${format("%s-elb-web-sg", var.name)}"

  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = "${var.web_port}"
    to_port     = "${var.web_port}"
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

resource "aws_elb" "elb-web" {
  name            = "${format("%s-elb-web", var.name)}"
  subnets         = "${var.vpc_public_subnets}"
  security_groups = ["${aws_security_group.elb_web.id}"]
  internal        = false

  listener {
    instance_port     = "${var.web_port}"
    instance_protocol = "http"
    lb_port           = "${var.web_port}"
    lb_protocol       = "http"
  }

  health_check {
      target              = "HTTP:${var.web_port}/go"
      interval            = "${var.web_elb_health_check_interval}"
      healthy_threshold   = "${var.web_elb_healthy_threshold}"
      unhealthy_threshold = "${var.web_elb_unhealthy_threshold}"
      timeout             = "${var.web_elb_health_check_timeout}"
      #interval            = 20
      #healthy_threshold   = 2
      #unhealthy_threshold = 2
      #timeout             = 5
  }

  tags = {
    "Terraform" : "true"
  }
}


#output "elb_dns_name" {
#value = "${aws_elb.elb_web.public_dns}"
