resource "alicloud_vpc" "this" {
  name       = var.name
  cidr_block = var.cidr_block
}

resource "alicloud_vswitch" "this" {
  for_each     = var.vswitches
  vpc_id       = alicloud_vpc.this.id
  cidr_block   = each.value.cidr
  zone_id      = each.value.az
  vswitch_name = "${var.name}-${each.key}"
}

output "vpc_id" {
  value = alicloud_vpc.this.id
}

output "vswitch_ids" {
  value = { for k, v in alicloud_vswitch.this : k => v.id }
}
