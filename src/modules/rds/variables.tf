variable "rds_sg_ids" {
  description = "The ID list of security groups for RDS"
  type        = list(string)
}
variable "rds_subnet_group_id" {
  description = "The subnet group name for RDS"
  type        = string
}