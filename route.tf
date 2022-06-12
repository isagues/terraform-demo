data "aws_route53_zone" "main" {
  name = local.base_domain
}

resource "aws_acm_certificate" "redes" {
  domain_name               = local.base_domain
  subject_alternative_names = [local.demo_domain, "www.${local.demo_domain}", local.demo_aws_domain, local.demo_gcp_domain]
  validation_method         = "DNS"
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.redes.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = data.aws_route53_zone.main.id
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}

resource "aws_acm_certificate_validation" "redes" {
  certificate_arn         = aws_acm_certificate.redes.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "www.${local.demo_domain}"
  type    = "CNAME"

  alias {
    name    = aws_route53_record.demo_primary.name
    zone_id =  data.aws_route53_zone.main.id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "aws" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "${local.demo_aws_domain}"
  type    = "A"

  alias {
    name    = aws_cloudfront_distribution.redes.domain_name
    zone_id = aws_cloudfront_distribution.redes.hosted_zone_id
    evaluate_target_health = false
  }
}

  # TODO(tobi): Falta NS de GCP

resource "aws_route53_health_check" "web" {
  port            = 443
  type              = "HTTPS"
  fqdn              = "${local.demo_aws_domain}"
  resource_path     = "/api/time"
  failure_threshold = "3"
  request_interval  = "30"
}

resource "aws_route53_record" "demo_primary" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "${local.demo_domain}"
  type    = "CNAME"
  ttl     = 300

  records = ["${local.demo_aws_domain}"]

    failover_routing_policy {
    type = "PRIMARY"
  }

  health_check_id = aws_route53_health_check.web.id

  set_identifier  = "record-demo-primary"
}


resource "aws_route53_record" "demo_secondary" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "${local.demo_domain}"
  type    = "CNAME"
  ttl     = 300

  records = ["${local.demo_gcp_domain}"]

    failover_routing_policy {
    type = "SECONDARY"
  }

  set_identifier  = "record-demo-secondary"
}

