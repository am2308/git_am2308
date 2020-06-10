variable "name" {
  description = "name"
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

variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "vpc_public_subnets" {
  description = "public subnets"
  type        = list(string)
}
