terraform {
  required_version = ">= 1.5.0"

  backend "oss" {
    bucket           = var.state_bucket
    prefix           = var.state_prefix
    region           = var.region
    tablestore_table = var.lock_table
  }
}
