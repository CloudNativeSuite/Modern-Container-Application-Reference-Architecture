resource "alicloud_kvstore_instance" "this" {
  instance_name  = var.name
  instance_class = var.instance_class
  engine_version = var.engine_version
  vswitch_id     = var.vswitch_id
  vpc_id         = var.vpc_id
  password       = var.password
  payment_type   = "PostPaid"
}

output "instance_id" {
  value = alicloud_kvstore_instance.this.id
}

output "connection_string" {
  value = alicloud_kvstore_instance.this.connection_domain
}
