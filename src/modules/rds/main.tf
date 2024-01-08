terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

resource "aws_db_instance" "master" {
  allocated_storage          = 10
  identifier                 = "master"
  db_name                    = "goormDB"
  engine                     = "mysql"
  engine_version             = "8.0"
  instance_class             = "db.t3.micro"
  username                   = "root"
  password                   = "foobarbaz"
  skip_final_snapshot        = true
  backup_retention_period    = 7
  deletion_protection        = false
  apply_immediately          = true
  publicly_accessible        = false
  auto_minor_version_upgrade = true
  # multi_az                   = true
  availability_zone          = var.master_az_name
  vpc_security_group_ids     = var.rds_sg_ids
  db_subnet_group_name       = var.rds_subnet_group_name
}

resource "aws_db_instance" "read_replica" {
  identifier                 = "goorm-replica"
  replicate_source_db        = aws_db_instance.master.identifier
  instance_class             = "db.t3.micro"
  deletion_protection        = false
  apply_immediately          = true
  publicly_accessible        = false
  skip_final_snapshot        = true
  auto_minor_version_upgrade = true
  vpc_security_group_ids     = var.rds_sg_ids
  availability_zone          = var.replica_az_name
}
