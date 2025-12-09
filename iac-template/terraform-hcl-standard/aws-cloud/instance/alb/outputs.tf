output "alb_arn" {
  value = module.alb.alb_arn
}

output "alb_dns" {
  value = module.alb.alb_dns
}

output "target_group_arns" {
  value = module.alb.target_group_arns
}
