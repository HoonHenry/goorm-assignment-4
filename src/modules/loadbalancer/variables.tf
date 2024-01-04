variable "lb_type" {
  description = "the type of the loadbalancer"
  type        = string
  default     = "application"
}

variable "vpc_id" {
  description = "the ID of the vitual private cloud to attach"
  type        = string
}

variable "web_sg_ids" {
  description = "the ID of the security group to attach for web load balancer"
  type        = list(string)
}

variable "app_sg_ids" {
  description = "the ID of the security group to attach for app load balancer"
  type        = list(string)
}

variable "app_subnet_ids" {
  description = "the list of the security group to attach for app load balancer"
  type        = list(string)
}

variable "web_subnet_ids" {
  description = "the list of the security group to attach for web load balancer"
  type        = list(string)
}

variable "web_tg_arn" {
  description = "the ARN of the target group for web load balancer"
  type        = string
}

variable "app_tg_arn" {
  description = "the ARN of the target group for app load balancer"
  type        = string
}