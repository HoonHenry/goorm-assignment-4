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

variable "asg_name" {
  description = "The name of autoscaling group"
  type        = string
}

variable "subnet_ids" {
  description = "The IDs of the subnets to place the EC2 instance in"
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
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
