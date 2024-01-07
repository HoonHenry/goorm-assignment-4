terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "groomVPC"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_subnet" "public_web" {
  vpc_id = aws_vpc.my_vpc.id

  count             = length(var.public_subnet_cidrs)
  availability_zone = "${var.vpc_region}${var.vpc_az_list[count.index]}"
  cidr_block        = var.public_subnet_cidrs[count.index]

  tags = {
    Name = "Public Web ${var.vpc_az_list[count.index]}"
  }
}

resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = aws_vpc.my_vpc.cidr_block
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "Web Route Table"
  }
}

resource "aws_route_table_association" "public_rtba" {
  count          = length(aws_subnet.public_web)
  subnet_id      = aws_subnet.public_web[count.index].id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_eip" "nat" {
  count  = length(aws_subnet.public_web)
  domain = "vpc"
}

resource "aws_nat_gateway" "public_nat" {
  count         = length(aws_subnet.public_web)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public_web[count.index].id

  depends_on = [aws_internet_gateway.my_igw]

  tags = {
    Name = "goormVPC-nat-${var.vpc_az_list[count.index]}"
  }
}

resource "aws_subnet" "private_app" {
  vpc_id = aws_vpc.my_vpc.id

  count             = length(var.private_subnet_cidrs)
  availability_zone = "${var.vpc_region}${var.vpc_az_list[count.index]}"
  cidr_block        = var.private_subnet_cidrs[count.index]

  tags = {
    Name = "Private App ${var.vpc_az_list[count.index]}"
  }
}

resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = aws_vpc.my_vpc.cidr_block
    gateway_id = "local"
  }

  tags = {
    Name = "App Route Table"
  }
}

resource "aws_route_table_association" "private_rtba" {
  count          = length(aws_subnet.private_app)
  subnet_id      = aws_subnet.private_app[count.index].id
  route_table_id = aws_route_table.private_rtb.id
}

resource "aws_subnet" "db_subnet" {
  vpc_id = aws_vpc.my_vpc.id

  count             = length(var.db_subnet_cidrs)
  availability_zone = "${var.vpc_region}${var.vpc_az_list[count.index]}"
  cidr_block        = var.db_subnet_cidrs[count.index]

  tags = {
    Name        = "Private DB ${var.vpc_az_list[count.index]}"
    Description = "Private subnet for DB in ${var.vpc_region}${var.vpc_az_list[count.index]}"
  }
}

resource "aws_route_table" "db_rtb" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "DB Route Table"
  }
}

resource "aws_route_table_association" "db_rtba" {
  count          = length(aws_subnet.db_subnet)
  subnet_id      = aws_subnet.db_subnet[count.index].id
  route_table_id = aws_route_table.db_rtb.id
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "rds_subnet_group"
  description = "Subnet group for RDS"

  subnet_ids = [
    for subnet in aws_subnet.db_subnet : subnet.id
  ]
}
