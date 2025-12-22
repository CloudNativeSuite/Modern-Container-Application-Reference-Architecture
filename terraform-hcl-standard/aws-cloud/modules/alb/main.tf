resource "aws_lb" "this" {
  name               = "${var.name_prefix}-alb"
  load_balancer_type = "application"
  subnets            = var.subnet_ids

  security_groups = []

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-alb"
  })
}

resource "aws_lb_target_group" "tg" {
  for_each = { for l in var.listeners : "${l.port}" => l }

  name        = "${var.name_prefix}-tg-${each.value.port}"
  port        = each.value.target_group_port
  protocol    = each.value.target_group_protocol
  vpc_id      = var.vpc_id
  target_type = "instance"
}

resource "aws_lb_listener" "listener" {
  for_each = { for l in var.listeners : "${l.port}" => l }

  load_balancer_arn = aws_lb.this.arn
  port              = each.value.port
  protocol          = each.value.protocol

  dynamic "default_action" {
    for_each = [1]
    content {
      type             = "forward"
      target_group_arn = aws_lb_target_group.tg[each.key].arn
    }
  }

  dynamic "certificate_arn" {
    for_each = each.value.certificate_arn != null ? [each.value.certificate_arn] : []
    content {
      certificate_arn = certificate_arn
    }
  }
}
