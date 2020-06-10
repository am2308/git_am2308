resource "aws_security_group" "app" {
  name = "${format("%s-app-sg", var.name)}"

  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = "${var.app_port}"
    to_port     = "${var.app_port}"
    protocol    = "tcp"
    cidr_blocks = "${var.public_subnets_cidr_blocks}"
  }

  ingress {
    from_port   = "${var.app_port}"
    to_port     = "${var.app_port}"
    protocol    = "tcp"
    cidr_blocks = "${var.private_subnets_cidr_blocks}"
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = "${var.public_subnets_cidr_blocks}"
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

resource "aws_launch_configuration" "app" {
  image_id        = "ami-0e34e7b9ca0ace12d"
  instance_type   = "${var.app_instance_type}"
  security_groups = ["${aws_security_group.app.id}"]
  #TODO REMOVE
  key_name = "terraform"
  name_prefix = "${var.name}-app-vm-"

  user_data = <<-EOF
              #!/bin/bash
              yum install -y git
              yum install -y docker
              systemctl start docker
              yum install -y java-1.8.0-openjdk-devel wget git
              export JAVA_HOME=/etc/alternatives/java_sdk_1.8.0
              source ~/.bashrc
              wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
              sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
              yum install -y apache-maven
              git clone https://github.com/opstree/spring3hibernate.git
              cd spring3hibernate/src/main/resources
              cat database.properties | grep mysql.okts.tk | sed -i "s/mysql.okts.tk:3306/${var.db_endpoint}/" database.properties
              cat database.properties | grep employeedb | sed -i "s/employeedb/${var.db_identifier}/" database.properties
              cat database.properties | grep user | sed -i "s/root/${var.db_username}/" database.properties
              cat database.properties | grep password | sed -i "s/=password/=${var.db_password}/" database.properties
              cd ../../..
              mvn clean package
              docker build -t spring3hibernate:latest .
              ImageId=$(docker images | grep spring | awk -F' ' '{print $3}')
              docker run -p ${var.app_port}:${var.app_port} --name spring3hibernate -d spring3hibernate:latest
              EOF

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "app" {
  launch_configuration = "${aws_launch_configuration.app.id}"

  vpc_zone_identifier = "${var.vpc_private_subnets}"
  #availability_zones  = ["us-west-2a","us-west-2b"]

  #load_balancers    = ["${module.elb_app.this_elb_name}"]
  health_check_type = "EC2"

  min_size = "${var.app_autoscale_min_size}"
  max_size = "${var.app_autoscale_max_size}"
}

resource "aws_autoscaling_attachment" "app" {
  autoscaling_group_name = "${aws_autoscaling_group.app.id}"
  elb                    = "${var.public_dns}"
}
