resource "aws_instance" "this" {
  ami           = var.instance.ami
  instance_type = var.instance.type

  # 明确由 env 层传入，无任何自动推断
  subnet_id = var.subnet_id

  vpc_security_group_ids = [var.sg_id]

  key_name = var.keypair_name

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-instance"
  })
}
