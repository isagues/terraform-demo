

locals {
  s3_origin_id = "ice-cream-static-site"
  api_origin_id = "nginx-api"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = local.s3_origin_id
}

data "aws_cloudfront_cache_policy" "disabled" {
    name = "Managed-CachingDisabled"
}

data "aws_cloudfront_cache_policy" "optimized" {
    name = "Managed-CachingOptimized"
}


resource "aws_cloudfront_distribution" "redes" {
  
  # Si se usa www hay problemas de permisos, la policy dice que solo cloudfront lee pega a site
  origin {
    domain_name = aws_s3_bucket.site.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }
  
  origin {
    domain_name = aws_lb.web.dns_name
    origin_id   = local.api_origin_id

    custom_origin_config {
        origin_protocol_policy = "http-only"
        origin_ssl_protocols = ["TLSv1.2"]
        https_port = 443
        http_port = 80
    }
  }

  enabled             = true
  is_ipv6_enabled     = false
  comment             = "cloudfront"
  default_root_object = "index.html"
  aliases = ["${local.redes_sub_domain}.${local.base_domain}"]

  # Configure logging here if required 	
  # logging_config {
  #  include_cookies = false
  #  bucket          = aws_s3_bucket.cdnlogs.id
  # #  prefix          = "myprefix"
  # }
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id
    cache_policy_id  = data.aws_cloudfront_cache_policy.optimized.id

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/api/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    cache_policy_id  = data.aws_cloudfront_cache_policy.disabled.id
    target_origin_id = local.api_origin_id

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    #   locations        = ["US", "CA", "GB", "DE", "IN", "IR"]
    }
  }

  tags = {
    Environment = "development"
    Name        = "my-tag"
  }

  viewer_certificate {
    acm_certificate_arn       = data.aws_acm_certificate.redes.arn
    minimum_protocol_version  = "TLSv1.2_2021"
    ssl_support_method = "sni-only"
  }
}

# # to get the Cloud front URL if doamin/alias is not configured
# output "cloudfront_domain_name" {
#   value = aws_cloudfront_distribution.redes.domain_name
# }

data "aws_iam_policy_document" "site" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.site.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

data "aws_iam_policy_document" "www" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.www.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "site" {
  bucket = aws_s3_bucket.site.id
  policy = data.aws_iam_policy_document.site.json
}

resource "aws_s3_bucket_policy" "www" {
  bucket = aws_s3_bucket.www.id
  policy = data.aws_iam_policy_document.www.json
}
