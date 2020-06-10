variable "name" {
  description = "Security group name"
  default     = "terraform-aws"
}

variable "app_port" {
  description = "The port on which the web servers listen for connections"
  default = 80
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

variable "vpc_azs" {
  description = "A list of availability zones in the region"
  type        = list(string)
  default     = []
}

variable "vpc_private_subnets" {
  description = "private subnets"
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

variable "public_subnets_cidr_blocks" {
  description = "public_subnets_cidr_blocks"
}

variable "private_subnets_cidr_blocks" {
  description = "private_subnets_cidr_blocks"
}

variable "db_identifier" {
  description = "db identifier"
}

variable "db_username" {
  description = "db user"
}

variable "db_password" {
  description = "db pass"
}

variable "db_endpoint" {
  description = "db endpoint"
}
