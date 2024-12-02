# Generate UUID for bucket name
resource "random_uuid" "bucket_name" {}

# S3 Bucket
resource "aws_s3_bucket" "csye6225_bucket" {
  bucket = "csye6255-${random_uuid.bucket_name.result}"

  force_destroy = true # Allows Terraform to delete non-empty bucket

  tags = {
    Name = "webapp-bucket"
  }
}

# Bucket private access
resource "aws_s3_bucket_public_access_block" "bucket_access" {
  bucket = aws_s3_bucket.csye6225_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable default encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.csye6225_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3_kms.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# Lifecycle policy
resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle" {
  bucket = aws_s3_bucket.csye6225_bucket.id

  rule {
    id     = "transition_to_ia"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}