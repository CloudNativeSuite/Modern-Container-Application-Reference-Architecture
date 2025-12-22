resource "aws_s3_bucket" "state" {
  count  = var.create_bucket ? 1 : 0
  bucket = local.bucket_name

  tags = merge(
    {
      Name        = local.bucket_name
      Environment = local.environment
    },
    local.tags,
  )
}

data "aws_s3_bucket" "existing" {
  count  = var.create_bucket ? 0 : 1
  bucket = local.bucket_name
}

resource "aws_s3_bucket_versioning" "versioning" {
  count  = var.create_bucket ? 1 : 0
  bucket = local.bucket_id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  count  = var.create_bucket ? 1 : 0
  bucket = local.bucket_id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  count  = var.create_bucket ? 1 : 0
  bucket = local.bucket_id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
