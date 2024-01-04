variable "tg_name" {
  description = "the name of target group to create"
  type        = string
}

variable "vpc_id" {
  description = "the id of the vpc to create the target group in"
  type        = string
}