name = "terraform-aws"

# VPC
vpc_azs = [ "us-west-2a", "us-west-2b" ]
vpc_cidr = "192.168.0.0/16"
vpc_private_subnets = ["192.168.1.0/24", "192.168.2.0/24"]
vpc_public_subnets  = ["192.168.101.0/24", "192.168.201.0/24"]
vpc_database_subnets = ["192.168.102.0/24", "192.168.202.0/24"]
vpc_enable_nat_gateway = true
vpc_single_nat_gateway = false
vpc_one_nat_gateway_per_az = true

#Web-Elb
web_port = 80
web_instance_type = "t2.micro"
web_autoscale_min_size = 2
web_autoscale_max_size = 3
web_elb_health_check_interval = 20
web_elb_healthy_threshold = 2
web_elb_unhealthy_threshold = 2
web_elb_health_check_timeout = 3

#DB
db_port = 3306
db_identifier = "demodb"
db_allocated_storage = 5
db_name = "demodb"
db_username = "demodb"
db_password = "Infosys23"
