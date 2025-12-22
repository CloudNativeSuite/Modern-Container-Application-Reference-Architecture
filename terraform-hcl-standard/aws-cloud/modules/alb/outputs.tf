output "alb_arn" {
  value = aws_lb.this.arn
}

output "alb_dns" {
  value = aws_lb.this.dns_name
}

output "target_group_arns" {
  value = { for k, tg in aws_lb_target_group.tg : k => tg.arn }
}
