output "app_sg_id" {
  value = aws_security_group.app_sg.id
}

output "web_sg_id" {
  value = aws_security_group.web_sg.id
}

# output "app_asg_sg_id" {
#   value = aws_security_group.app_asg_sg.id
# }

# output "web_asg_sg_id" {
#   value = aws_security_group.web_asg_sg.id
# }
