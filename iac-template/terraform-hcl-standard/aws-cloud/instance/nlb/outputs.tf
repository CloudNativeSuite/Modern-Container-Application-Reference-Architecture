output "nlb_arn" {
  value = module.nlb.nlb_arn
}

output "nlb_dns" {
  value = module.nlb.nlb_dns
}

output "target_group_arns" {
  value = module.nlb.target_group_arns
}
