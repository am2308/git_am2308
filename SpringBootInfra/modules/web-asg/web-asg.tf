resource "aws_security_group" "web" {
  name = "${format("%s-web-sg", var.name)}"

  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = "${var.web_port}"
    to_port     = "${var.web_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "65535"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Group : "${var.name}"
  }

}

#TODO REMOVE
#resource "aws_key_pair" "web-key" {
#  key_name = "web-key"
#  public_key = "${var.public_key}"

#}

resource "aws_launch_configuration" "web" {
  image_id        = "ami-0e34e7b9ca0ace12d"
  instance_type   = "${var.web_instance_type}"
  security_groups = ["${aws_security_group.web.id}"]
  #TODO REMOVE
  key_name = "terraform"
  name_prefix = "${var.name}-web-vm-"

  user_data = <<-EOF
              #!/bin/bash
              yum install -y git
              yum install -y docker
              systemctl start docker
              git clone https://github.com/opstree/spring3hibernate.git
              cd spring3hibernate/nginx
              #var="my-loadbalancer-1234567890.us-west-2.elb.amazonaws.com"
              cat default.conf | grep server_name | sed -i "s/ingress.okts.tk/${var.public_dns}/" default.conf
              cat default.conf | grep spring3hibernate.okts.tk | sed -i "s/spring3hibernate.okts.tk/${var.public_dns}/" default.conf
              docker build -t nginx:latest .
              ImageId=$(docker images | grep latest | awk -F' ' '{print $3}')
              docker run -p ${var.web_port}:${var.web_port} --name ngnix -d nginx:latest
              EOF

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "web" {
  launch_configuration = "${aws_launch_configuration.web.id}"

  vpc_zone_identifier = "${var.vpc_public_subnets}"
  #availability_zones  = ["us-west-2a","us-west-2b"]

  #load_balancers    = "${var.public_dns}"
  health_check_type = "EC2"

  min_size = "${var.web_autoscale_min_size}"
  max_size = "${var.web_autoscale_max_size}"

}

resource "aws_autoscaling_attachment" "web" {
  autoscaling_group_name = "${aws_autoscaling_group.web.id}"
  elb                    = "${var.id}"
  #elb                     = "${module.web-elb.this_elb_id}"
}
