variable "rds_sg_ids" {
  description = "The ID list of security groups for RDS"
  type        = list(string)
}
variable "rds_subnet_group_name" {
  description = "The subnet group name for RDS"
  type        = string
}

variable "master_az_name" {
  description = "The name of availability zone for master"
  type        = string
  default     = "ap-northeast-2a"
}
variable "replica_az_name" {
  description = "The name of availability zone for replica"
  type        = string
  default     = "ap-northeast-2c"
}
