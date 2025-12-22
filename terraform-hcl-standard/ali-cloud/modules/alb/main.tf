resource "alicloud_alb_load_balancer" "this" {
  load_balancer_name    = var.name
  address_type          = var.address_type
  load_balancer_edition = var.edition
  vpc_id                = var.vpc_id
  address_allocated_mode = "Dynamic"

  dynamic "zone_mappings" {
    for_each = var.zone_mappings
    content {
      vswitch_id = zone_mappings.value.vswitch_id
      zone_id    = zone_mappings.value.zone_id
    }
  }
}

resource "alicloud_alb_server_group" "this" {
  server_group_name = "${var.name}-sg"
  vpc_id            = var.vpc_id
  protocol          = var.protocol
}

resource "alicloud_alb_listener" "http" {
  load_balancer_id = alicloud_alb_load_balancer.this.id
  listener_port    = var.listener_port
  listener_protocol = var.protocol

  default_actions {
    type = "ForwardGroup"

    forward_group_config {
      server_group_tuples {
        server_group_id = alicloud_alb_server_group.this.id
      }
    }
  }
}

output "alb_id" {
  value = alicloud_alb_load_balancer.this.id
}

output "listener_id" {
  value = alicloud_alb_listener.http.id
}

output "server_group_id" {
  value = alicloud_alb_server_group.this.id
}
