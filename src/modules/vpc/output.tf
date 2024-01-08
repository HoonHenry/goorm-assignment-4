output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "vpc_name" {
  value = aws_vpc.my_vpc.tags["Name"]
}

output "web_subnet_ids" {
  value = aws_subnet.public_web.*.id
}

output "app_subnet_ids" {
  value = aws_subnet.private_app.*.id
}

output "rds_subnet_group_name" {
  value = aws_db_subnet_group.rds_subnet_group.name
}
