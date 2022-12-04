provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "state-bucket" {
  bucket = "state-bucket-122022"
}

resource "aws_s3_bucket_acl" "control_list" {
  bucket = aws_s3_bucket.state-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_policy" {
  bucket = aws_s3_bucket.state-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_kms_key" "schlussel" {
  description             = "the key that we use to encrypt"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "crypt_config" {
  bucket = aws_s3_bucket.state-bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.schlussel.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_dynamodb_table" "terraform_locker" {
  name         = "terraform-locker-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}