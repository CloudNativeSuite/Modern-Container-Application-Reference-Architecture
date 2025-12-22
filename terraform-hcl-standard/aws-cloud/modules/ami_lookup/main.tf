locals {
  name = var.name

  # OS type flags
  is_ubuntu_2204 = local.name == "ubuntu_2204"
  is_ubuntu_2404 = local.name == "ubuntu_2404"
  is_rocky_8     = local.name == "rocky_8"
  is_rocky_9     = local.name == "rocky_9"
  is_rocky_10    = local.name == "rocky_10"
  is_amzn2       = local.name == "amazonlinux_2"

  # Filters（每种 OS 一个准确 pattern）
  ami_filters = (
    local.is_ubuntu_2204 ? [
      "ubuntu/images/hvm-ssd-gp3/ubuntu-jammy-22.04-amd64-server-*"
    ] :
    local.is_ubuntu_2404 ? [
      "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
    ] :
    local.is_rocky_8 ? [
      "Rocky-8-*-x86_64-*"
    ] :
    local.is_rocky_9 ? [
      "Rocky-9-*-x86_64-*"
    ] :
    local.is_rocky_10 ? [
      "Rocky-10-*-x86_64-*"
    ] :
    local.is_amzn2 ? [
      "amzn2-ami-hvm-*-x86_64-gp2"
    ] :
    ["*"]
  )

  # AMI Owner IDs
  ami_owners = (
    (local.is_rocky_8 || local.is_rocky_9 || local.is_rocky_10) ? ["679593333241"] :
    (local.is_ubuntu_2204 || local.is_ubuntu_2404) ? ["099720109477"] :
    local.is_amzn2 ? ["137112412989"] :
    ["amazon"]
  )
}

data "aws_ami" "selected" {
  most_recent = true
  owners      = local.ami_owners

  dynamic "filter" {
    for_each = local.ami_filters
    content {
      name   = "name"
      values = [filter.value]
    }
  }
}

output "ami_id" {
  value       = data.aws_ami.selected.id
  description = "Resolved AMI ID"
}
