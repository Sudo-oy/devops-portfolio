# terraform/s3.tf
resource "aws_s3_bucket" "devops_bucket" {
  bucket = "devops-portfolio-bucket-${random_id.bucket_id.hex}"
  acl    = "private"

  tags = {
    Name = "devops-portfolio-bucket"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "devops_bucket_lifecycle" {
  bucket = aws_s3_bucket.devops_bucket.id

  rule {
    id     = "ExpireOldObjects"
    status = "Enabled"

    expiration {
      days = 30
    }

    prefix = ""
  }
}

resource "random_id" "bucket_id" {
  byte_length = 4
}
