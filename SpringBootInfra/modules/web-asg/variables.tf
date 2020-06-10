variable "name" {
  description = "Security group name"
  default     = "terraform-aws"
}

variable "web_port" {
  description = "The port on which the web servers listen for connections"
  default = 80
}

variable "web_instance_type" {
  description = "The EC2 instance type for the web servers"
  default = "t2.micro"
}

variable "web_autoscale_min_size" {
  description = "The fewest amount of EC2 instances to start"
  default = 2
}

variable "web_autoscale_max_size" {
  description = "The largest amount of EC2 instances to start"
  default = 3
}

variable "vpc_azs" {
  description = "A list of availability zones in the region"
  type        = list(string)
  default     = []
}

variable "vpc_public_subnets" {
  description = "public subnets"
  type        = list(string)
}

variable "public_dns" {
  description = "load balancer"
  type        = string
}

variable "vpc_id" {
  description = "vpc_id"
  type        = string
}


variable "id" {
  description = "elb id"
}
