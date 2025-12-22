resource "alicloud_slb_load_balancer" "this" {
  name                 = var.name
  address_type         = var.address_type
  load_balancer_spec   = var.spec
  vswitch_id           = var.vswitch_id
  internet_charge_type = "paybytraffic"
}

resource "alicloud_slb_server_group" "this" {
  load_balancer_id = alicloud_slb_load_balancer.this.id
  name             = "${var.name}-sg"
}

resource "alicloud_slb_listener" "tcp" {
  load_balancer_id = alicloud_slb_load_balancer.this.id
  backend_port     = var.backend_port
  frontend_port    = var.frontend_port
  bandwidth        = -1
  protocol         = var.protocol

  health_check {
    health_check_interval = 5
    healthy_threshold     = 3
    unhealthy_threshold   = 3
  }
}

output "nlb_id" {
  value = alicloud_slb_load_balancer.this.id
}

output "listener_id" {
  value = alicloud_slb_listener.tcp.id
}
