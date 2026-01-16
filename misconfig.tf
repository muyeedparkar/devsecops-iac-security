provider "aws" {
  region = "us-east-1"
}

# ⚠️ VULNERABLE CODE:
# This S3 bucket is missing encryption and public access blocks.
# A security tool should catch this!
resource "aws_s3_bucket" "bad_bucket" {
  bucket_prefix = "unsafe-bucket"
}
