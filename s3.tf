# S3 bucket for static website.
resource "aws_s3_bucket" "www_bucket" {
  bucket = "www.${var.bucket_name}"
  acl = "public-read"
  policy = templatefile("templates/s3-policy.json", { bucket = "www.${var.bucket_name}" })

  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://www.${var.domain_name}"]
    max_age_seconds = 3000
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = var.common_tags
}


# S3 non_www_bucket bucket for redirecting non-www requests  to www.
resource "aws_s3_bucket" "non_www_bucket" {
  bucket = var.bucket_name
  acl = "public-read"
  policy = templatefile("templates/s3-policy.json", { bucket = var.bucket_name })

  website {
    redirect_all_requests_to = "https://www.${var.domain_name}"
  }

  tags = var.common_tags
}

#Upload files of your static website
resource "aws_s3_bucket_object" "html" {
  for_each = fileset("mywebsite/", "**/*.html")

  bucket = aws_s3_bucket.www_bucket.bucket
  key    = each.value
  source = "mywebsite/${each.value}"
  etag   = filemd5("mywebsite/${each.value}")
  content_type = "text/html"
}
