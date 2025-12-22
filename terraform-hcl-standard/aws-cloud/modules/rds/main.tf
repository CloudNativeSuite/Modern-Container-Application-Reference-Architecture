resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-subnet-group"
  })
}

resource "aws_db_parameter_group" "this" {
  name   = "${var.name_prefix}-pg"
  family = "${var.engine}${substr(var.engine_version, 0, 2)}"  # auto detect "postgres15"

  dynamic "parameter" {
    for_each = var.parameters

    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-pg"
  })
}

resource "aws_db_instance" "this" {
  identifier              = var.name_prefix

  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class

  username                = var.username
  password                = var.password

  allocated_storage       = var.allocated_storage
  max_allocated_storage   = var.max_allocated_storage

  multi_az                = var.multi_az
  publicly_accessible     = var.publicly_accessible

  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = var.vpc_security_group_ids
  parameter_group_name    = aws_db_parameter_group.this.name

  skip_final_snapshot     = true

  tags = merge(var.tags, {
    Name = var.name_prefix
  })
}
