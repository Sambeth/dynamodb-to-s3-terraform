module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "samuel-baafi-boakye-athena-queries"
  acl    = "private"
  force_destroy = true

  versioning = {
    enabled = true
  }

  policy = jsonencode({
    Version = "2012-10-17"
    Id = "CUSTOMERORDERSBUCKETPOLICY"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "s3:*"
        Resource = "*"
      }
    ]
  })
}