terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  # enable_dns_hostnames = true
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
}

resource "aws_route_table_association" "public_rtba" {
  subnet_id      = aws_subnet.public_web.id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "public_nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_web.id
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

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.public_nat.id
  }
}

resource "aws_route_table_association" "private_rtba" {
  subnet_id      = aws_subnet.private_app.id
  route_table_id = aws_route_table.private_rtb.id
}
