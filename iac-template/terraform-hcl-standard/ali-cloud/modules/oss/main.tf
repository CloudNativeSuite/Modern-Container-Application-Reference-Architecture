resource "alicloud_oss_bucket" "this" {
  bucket = var.name

  versioning {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }

  server_side_encryption_rule {
    sse_algorithm = var.sse_algorithm
  }
}

resource "alicloud_oss_bucket_acl" "this" {
  bucket = alicloud_oss_bucket.this.bucket
  acl    = var.acl
}

output "bucket" {
  value = alicloud_oss_bucket.this.bucket
}
