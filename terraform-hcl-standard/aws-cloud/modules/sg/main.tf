resource "aws_security_group" "this" {
  name   = var.name
  vpc_id = var.vpc_id

  tags = merge(var.tags, {
    Name = var.name
  })
}

# Merge SSH rule + additional_ingress → 单一入口
locals {
  ingress_rules = concat(
    length(var.ssh_cidr) > 0 ? [
      {
        port     = 22
        protocol = "tcp"
        cidr     = var.ssh_cidr
      }
    ] : [],
    var.additional_ingress
  )
}

resource "aws_security_group_rule" "ingress" {
  for_each = { for idx, rule in local.ingress_rules : idx => rule }

  type              = "ingress"
  from_port         = each.value.port
  to_port           = each.value.port
  protocol          = each.value.protocol
  cidr_blocks       = [each.value.cidr]
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}
