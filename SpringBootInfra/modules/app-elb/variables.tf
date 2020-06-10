variable "name" {
  description = "name"
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

variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "vpc_private_subnets" {
  description = "private subnets"
  type        = list(string)
}
