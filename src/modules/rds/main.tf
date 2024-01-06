terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

resource "aws_db_instance" "primary" {
  allocated_storage      = 10
  identifier             = "primary"
  db_name                = "primary"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "root"
  password               = "foobarbaz"
  parameter_group_name   = "primary.mysql8.0"
  skip_final_snapshot    = true
  vpc_security_group_ids = var.rds_sg_ids
  db_subnet_group_name   = var.rds_subnet_group_id
}

resource "aws_db_instance" "read-replica" {
  replicate_source_db = aws_db_instance.primary.identifier
  replica_mode        = "mounted"
  identifier          = "read-replica"
  instance_class      = "db.t3.micro"
  skip_final_snapshot = true
  # backup_retention_period    = 7
  # auto_minor_version_upgrade = false
}


