resource "alicloud_security_group" "this" {
  name   = "${var.name}-sg"
  vpc_id = var.vpc_id
}

resource "alicloud_security_group_rule" "ssh" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = alicloud_security_group.this.id
  cidr_ip           = var.ssh_cidr
}

resource "alicloud_instance" "this" {
  instance_name              = var.name
  host_name                  = var.name
  image_id                   = var.image_id
  instance_type              = var.instance_type
  vswitch_id                 = var.vswitch_id
  security_groups            = [alicloud_security_group.this.id]
  system_disk_category       = var.system_disk_category
  system_disk_size           = var.system_disk_size
  internet_max_bandwidth_out = var.internet_max_bandwidth_out
  key_name                   = var.key_name
  user_data                  = var.user_data
}

output "instance_id" {
  value = alicloud_instance.this.id
}

output "private_ip" {
  value = alicloud_instance.this.private_ip
}
