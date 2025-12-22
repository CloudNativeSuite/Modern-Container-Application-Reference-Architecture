resource "alicloud_db_instance" "this" {
  engine                   = var.engine
  engine_version           = var.engine_version
  instance_type            = var.instance_type
  db_instance_storage_type = var.storage_type
  db_instance_storage      = var.storage
  instance_charge_type     = "PostPaid"
  vswitch_id               = var.vswitch_id
  vpc_id                   = var.vpc_id
  security_ip_list         = join(",", var.security_ips)
}

resource "alicloud_db_account" "this" {
  db_instance_id   = alicloud_db_instance.this.id
  account_name     = var.account_name
  account_password = var.account_password
}

resource "alicloud_db_database" "this" {
  count           = var.create_database ? 1 : 0
  db_instance_id  = alicloud_db_instance.this.id
  name            = var.database_name
  character_set   = "utf8mb4"
  description     = "managed by terraform"
}

output "instance_id" {
  value = alicloud_db_instance.this.id
}

output "connection_string" {
  value = alicloud_db_instance.this.connection_string
}
