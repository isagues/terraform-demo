data "aws_acm_certificate" "redes" {
  domain      = local.base_domain
  statuses    = ["ISSUED"]
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

data "aws_route53_zone" "main" {
  name = local.base_domain
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "${local.redes_sub_domain}.${data.aws_route53_zone.main.name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.redes.domain_name
    zone_id                = aws_cloudfront_distribution.redes.hosted_zone_id
    evaluate_target_health = true
  }
}