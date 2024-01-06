variable "vpc_region" {
  description = "The AWS region to create resources in"
  type        = string
  default     = "ap-northeast-2"
}

variable "vpc_az_list" {
  description = "List of availability zones for the subnets"
  type        = list(string)
  default     = ["a", "c"]
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of public CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.0.0/20", "10.0.16.0/20"]
}

variable "private_subnet_cidrs" {
  description = "List of private CIDR blocks for the subnets"
  type        = list(string)
  default     = ["10.0.32.0/20", "10.0.48.0/20"]
}

variable "db_subnet_cidrs" {
  description = "List of private CIDR blocks for the private db"
  type        = list(string)
  default     = ["10.0.64.0/20", "10.0.80.0/20"]
}
