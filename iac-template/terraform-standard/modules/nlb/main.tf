resource "aws_lb" "this" {
  name               = "${var.name_prefix}-nlb"
  load_balancer_type = "network"
  subnets            = var.subnet_ids

  idle_timeout = 60

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-nlb"
  })
}

resource "aws_lb_target_group" "tg" {
  for_each = { for l in var.listeners : "${l.port}" => l }

  name        = "${var.name_prefix}-tg-${each.value.port}"
  port        = each.value.target_group_port
  protocol    = each.value.target_group_protocol
  target_type = "instance"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "listener" {
  for_each = { for l in var.listeners : "${l.port}" => l }

  load_balancer_arn = aws_lb.this.arn
  port              = each.value.port
  protocol          = each.value.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg[each.key].arn
  }
}
