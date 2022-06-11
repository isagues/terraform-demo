resource "aws_s3_bucket" "site" {
  bucket_prefix = "site"
}

resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "site" {
  bucket = aws_s3_bucket.site.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "www" {
  bucket = "www.${aws_s3_bucket.site.id}"
}

resource "aws_s3_bucket_public_access_block" "www" {
  bucket = aws_s3_bucket.www.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_website_configuration" "www" {
  bucket = aws_s3_bucket.www.id

  redirect_all_requests_to {
    host_name = aws_s3_bucket.site.id
  }
}

###
# Upload files
###

locals {
  ss_src = "ice-cream"
}

#Upload files of your static website
resource "aws_s3_object" "html" {
  for_each = fileset("${local.ss_src}/", "**/*.html")

  bucket = aws_s3_bucket.site.bucket
  key    = each.value
  source = "${local.ss_src}/${each.value}"
  etag   = filemd5("${local.ss_src}/${each.value}")
  content_type = "text/html"
}

resource "aws_s3_object" "svg" {
  for_each = fileset("${local.ss_src}/", "**/*.svg")

  bucket = aws_s3_bucket.site.bucket
  key    = each.value
  source = "${local.ss_src}/${each.value}"
  etag   = filemd5("${local.ss_src}/${each.value}")
  content_type = "image/svg+xml"
}

resource "aws_s3_object" "css" {
  for_each = fileset("${local.ss_src}/", "**/*.css")

  bucket = aws_s3_bucket.site.bucket
  key    = each.value
  source = "${local.ss_src}/${each.value}"
  etag   = filemd5("${local.ss_src}/${each.value}")
  content_type = "text/css"
}

resource "aws_s3_object" "js" {
  for_each = fileset("${local.ss_src}/", "**/*.js")

  bucket = aws_s3_bucket.site.bucket
  key    = each.value
  source = "${local.ss_src}/${each.value}"
  etag   = filemd5("${local.ss_src}/${each.value}")
  content_type = "application/javascript"
}

resource "aws_s3_object" "images" {
  for_each = fileset("${local.ss_src}/", "**/*.jpg")

  bucket = aws_s3_bucket.site.bucket
  key    = each.value
  source = "${local.ss_src}/${each.value}"
  etag   = filemd5("${local.ss_src}/${each.value}")
  content_type = "image/jpg"
}

# resource "aws_s3_object" "json" {
#   for_each = fileset("${local.ss_src}/", "**/*.json")

#   bucket = aws_s3_bucket.site.bucket
#   key    = each.value
#   source = "${local.ss_src}/${each.value}"
#   etag   = filemd5("${local.ss_src}/${each.value}")
#   content_type = "application/json"
# }
# Add more aws_s3_bucket_object for the type of files you want to upload
# The reason for having multiple aws_s3_bucket_object with file type is to make sure
# we add the correct content_type for the file in S3. Otherwise website load may have issues
