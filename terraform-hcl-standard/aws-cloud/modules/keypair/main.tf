resource "aws_key_pair" "this" {
  key_name   = var.name
  public_key = var.public_key

  tags = merge(var.tags, {
    Name = var.name
  })
}

