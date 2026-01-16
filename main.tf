provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "secure_bucket" {
  bucket_prefix = "secure-bucket"

  # --- SECURITY EXCEPTIONS (Suppressions) ---
  # We place these INSIDE the resource so Checkov cannot miss them.
  # checkov:skip=CKV_AWS_18: "Access logging not needed for simple demo"
  # checkov:skip=CKV_AWS_144: "Cross-region replication is too expensive for demo"
  # checkov:skip=CKV_AWS_145: "Standard AES-256 encryption is sufficient (No KMS needed)"
  # checkov:skip=CKV2_AWS_61: "Lifecycle configuration not needed for demo"
  # checkov:skip=CKV2_AWS_62: "Event notifications not needed for demo"
}

# 1. Enforce Encryption (Passes CKV_AWS_19)
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 2. Block Public Access (Passes CKV_AWS_53, 54, 55, 56)
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.secure_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 3. Enable Versioning (Passes CKV_AWS_21)
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.secure_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
