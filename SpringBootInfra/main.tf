provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

variable "name" {
  description = "Name of vpc"
  default     = "Terraform-vpc"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overriden"
  default     = "0.0.0.0/0"
}

variable "vpc_public_subnets" {
  type = list(string)
  description = "A list of public subnets inside the VPC"
  default     = []
}

variable "vpc_private_subnets" {
  type = list(string)
  description = "A list of private subnets inside the VPC"
  default     = []
}

variable "vpc_database_subnets" {
  type        = list(string)
  description = "A list of database subnets"
  default     = []
}

variable "vpc_azs" {
  type        = list(string)
  description = "A list of availability zones in the region"
  default     = []
}

variable "vpc_enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  default     = false
}

variable "vpc_single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  default     = false
}

variable "vpc_one_nat_gateway_per_az" {
  description = "Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs`."
  default     = false
}

variable "web_elb_health_check_interval" {
  description = "Duration between health checks"
  default = 20
}

variable "web_elb_healthy_threshold" {
  description = "Number of checks before an instance is declared healthy"
  default = 2
}

variable "web_elb_unhealthy_threshold" {
  description = "Number of checks before an instance is declared unhealthy"
  default = 2
}

variable "web_elb_health_check_timeout" {
  description = "Interval between checks"
  default = 5
}

variable "web_port" {
  description = "prot"
  default     = 80
}
variable "web_instance_type" {
  description = "inst type"
  default     = "t2.micro"
}

variable "web_autoscale_min_size" {
  description = "min size"
  default     = 2
}

variable "web_autoscale_max_size" {
  description = "max size"
  default     = 3
}

variable "app_elb_health_check_interval" {
  description = "Duration between health checks"
  default = 20
}

variable "app_elb_healthy_threshold" {
  description = "Number of checks before an instance is declared healthy"
  default = 2
}

variable "app_elb_unhealthy_threshold" {
  description = "Number of checks before an instance is declared unhealthy"
  default = 2
}

variable "app_elb_health_check_timeout" {
  description = "Interval between checks"
  default = 5
}

variable "app_port" {
  description = "prot"
  default     = 8080
}


variable "app_instance_type" {
  description = "The EC2 instance type for the web servers"
  default = "t2.micro"
}

variable "app_autoscale_min_size" {
  description = "The fewest amount of EC2 instances to start"
  default = 2
}

variable "app_autoscale_max_size" {
  description = "The largest amount of EC2 instances to start"
  default = 3
}

variable "db_port" {
  description = "db port"
  default = 3306
}

variable "db_name" {
  description = "db name"
  default = "demodb"
}

variable "db_identifier" {
  description = "db identifier"
}

variable "db_allocated_storage" {
  description = "db_allocated_storage"
}

variable "db_username" {
  description = "db username"
}

variable "db_password" {
  description = "db password"
}

#module "vpc" {
#  source = "./modules/vpc"
#  name                       = var.name
#  vpc_cidr                   = var.vpc_cidr
#  vpc_public_subnets         = var.vpc_public_subnets
#  vpc_azs                    = var.vpc_azs
#  vpc_private_subnets        = var.vpc_private_subnets
#  vpc_database_subnets       = var.vpc_database_subnets
#  vpc_enable_nat_gateway     = var.vpc_enable_nat_gateway
#  vpc_single_nat_gateway     = var.vpc_single_nat_gateway
#  vpc_one_nat_gateway_per_az = var.vpc_one_nat_gateway_per_az
#}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.name}"
  azs = "${var.vpc_azs}"
  cidr = "${var.vpc_cidr}"

  public_subnets = "${var.vpc_public_subnets}"
  private_subnets = "${var.vpc_private_subnets}"
  database_subnets = "${var.vpc_database_subnets}"

  enable_nat_gateway = "${var.vpc_enable_nat_gateway}"
  single_nat_gateway = "${var.vpc_single_nat_gateway}"
  one_nat_gateway_per_az = "${var.vpc_one_nat_gateway_per_az}"

  tags = {
    Group : "${var.name}"
  }
}
module "web-elb" {
  source = "./modules/web-elb"

  name = "${format("%s-web-elb", var.name)}"
  web_port = "${var.web_port}"
  web_instance_type = "${var.web_instance_type}"
  web_autoscale_min_size = "${var.web_autoscale_min_size}"
  web_autoscale_max_size = "${var.web_autoscale_max_size}"
  web_elb_health_check_interval = "${var.web_elb_health_check_interval}"
  web_elb_healthy_threshold = "${var.web_elb_healthy_threshold}"
  web_elb_unhealthy_threshold = "${var.web_elb_unhealthy_threshold}"
  web_elb_health_check_timeout = "${var.web_elb_health_check_timeout}"
  vpc_id                       = "${module.vpc.vpc_id}"
  vpc_public_subnets           = "${module.vpc.public_subnets}"
}

#Calling app-elb module
module "app-elb" {
  source = "./modules/app-elb"

  name = "${format("%s-app-elb", var.name)}"
  app_port = "${var.app_port}"
  app_elb_health_check_interval = "${var.app_elb_health_check_interval}"
  app_elb_healthy_threshold = "${var.app_elb_healthy_threshold}"
  app_elb_unhealthy_threshold = "${var.app_elb_unhealthy_threshold}"
  app_elb_health_check_timeout = "${var.app_elb_health_check_timeout}"
  vpc_id                       = "${module.vpc.vpc_id}"
  vpc_private_subnets           = "${module.vpc.private_subnets}"
}

module "web-asg" {
  source = "./modules/web-asg"
  name = "${format("%s-web-asg", var.name)}"
  web_port = "${var.web_port}"
  web_instance_type = "${var.web_instance_type}"
  web_autoscale_min_size = "${var.web_autoscale_min_size}"
  web_autoscale_max_size = "${var.web_autoscale_max_size}"
  vpc_azs                = "${var.vpc_azs}"
  vpc_public_subnets     = "${module.vpc.public_subnets}"
  id                     = "${module.web-elb.id}"
  public_dns             = "${module.app-elb.dns_name}"
  vpc_id                 = "${module.vpc.vpc_id}"
}


resource "aws_security_group" "rds" {
  name = "${format("%s-rds-sg", var.name)}"

  vpc_id = "${module.vpc.vpc_id}"

  ingress {
    from_port   = "${var.db_port}"
    to_port     = "${var.db_port}"
    protocol    = "tcp"
    cidr_blocks = "${module.vpc.private_subnets_cidr_blocks}"
  }

  tags = {
    Group : "${var.name}"
  }

}

module "rds" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "${var.db_identifier}"

  engine            = "mysql"
  engine_version    = "5.7.19"
  instance_class    = "db.t2.micro"
  allocated_storage = "${var.db_allocated_storage}"

  name = "${var.db_name}"
  username = "${var.db_username}"
  password = "${var.db_password}"
  port     = "${var.db_port}"

  vpc_security_group_ids = ["${aws_security_group.rds.id}"]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  subnet_ids = "${module.vpc.database_subnets}"

  family = "mysql5.7"
  major_engine_version = "5.7"
  multi_az = "true"

  tags  = {
    Group : "${var.name}"
  }

}


#Calling app-asg module
module "app-asg" {
  source                      = "./modules/app-asg"
  name                        = "${format("%s-app-asg", var.name)}"
  app_port                    = "${var.app_port}"
  app_instance_type           = "${var.app_instance_type}"
  app_autoscale_min_size      = "${var.app_autoscale_min_size}"
  app_autoscale_max_size      = "${var.app_autoscale_max_size}"
  vpc_azs                     = "${var.vpc_azs}"
  vpc_private_subnets         = "${module.vpc.private_subnets}"
  public_dns                  = "${module.app-elb.id}"
  vpc_id                      = "${module.vpc.vpc_id}"
  public_subnets_cidr_blocks  = "${module.vpc.public_subnets_cidr_blocks}"
  private_subnets_cidr_blocks = "${module.vpc.private_subnets_cidr_blocks}"
  db_identifier               = "${var.db_identifier}"
  db_username                 = "${var.db_username}"
  db_password                 = "${var.db_password}"
  db_endpoint                 = "${module.rds.this_db_instance_endpoint}"
}
