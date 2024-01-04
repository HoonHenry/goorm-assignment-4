output "app_tg_arn" {
  value = aws_lb_target_group.app_lb_tg.arn
}

output "web_tg_arn" {
  value = aws_lb_target_group.web_lb_tg.arn
}
