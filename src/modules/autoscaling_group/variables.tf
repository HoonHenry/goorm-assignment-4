variable "app_sg_ids" {
  description = "The ID list for the app autoscaling group"
  type        = list(string)
}

variable "web_sg_ids" {
  description = "The ID list for the web autoscaling group"
  type        = list(string)
}

variable "ami" {
  description = "The AMI to use for the EC2 instance"
  type        = string
  default     = "ami-09eb4311cbaecf89d"
}

variable "instance_type" {
  description = "The instance type of the EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "min_size" {
  description = "the minimum size of the instance for the autoscaling group"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "the maximum size of the instance for the autoscaling group"
  type        = number
  default     = 6
}

variable "desired_capacity" {
  description = "the desired number of the instance for the autoscaling group"
  type        = number
  default     = 2
}

variable "app_subnet_ids" {
  description = "The IDs list for app"
  type        = list(string)
}

variable "web_subnet_ids" {
  description = "The IDs list for web"
  type        = list(string)
}

variable "app_tg_arn" {
  description = "The ID of the app target group"
  type        = string
}

variable "web_tg_arn" {
  description = "The ID of the web target group"
  type        = string
}
