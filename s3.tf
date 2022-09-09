 # S3 bucket for website.
resource "aws_s3_bucket" "www_bucket" {
  bucket = "www.${var.bucket_name}"
  acl = "public-read"
  policy = templatefile("templates/s3-policy.json", { bucket = "www.${var.bucket_name}" })
  tags = var.common_tags
}

resource "aws_s3_bucket_cors_configuration" "cors_conf" {
  bucket = aws_s3_bucket.www_bucket.id

  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://www.${var.domain_name}"]
    max_age_seconds = 3000
    #expose_headers  = ["ETag"]
 }

}

resource "aws_s3_bucket_website_configuration" "website_conf" {
  bucket = aws_s3_bucket.www_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}




# S3 bucket for redirecting non-www to www.
resource "aws_s3_bucket" "root_bucket" {
  bucket = var.bucket_name
  acl = "public-read"
  policy = templatefile("templates/s3-policy.json", { bucket = var.bucket_name })
  website{
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