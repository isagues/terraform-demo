terraform {
  backend "s3" {
    bucket = "state20220612191903685300000001"
    key    = "state"
    region = "us-east-1"
    encrypt = true
    kms_key_id = "be2bd5b2-cc3a-4cdd-828b-98dc545af5a3"
  }
}

module "vpc" {
    source = "./modules/vpc"

    cidr_block = var.cidr_block
    zones_count = var.zones_count
}

resource "aws_key_pair" "redes_key" {
  key_name   = var.key_name
  public_key = file(var.key_path)
}

module "bastion" {
    source = "./modules/bastion"

    vpc_id        = module.vpc.vpc_id
    subnets       = module.vpc.public_subnets_ids
    key_name      = var.key_name
    ami           = var.ami
    my_ips        = var.my_ips
    instance_type = var.instance_type
}

data "template_file" "web_server_ud" {
  template = file(var.web_server_ud_path)
}

module "web_server" {
    source = "./modules/web_server"

    vpc_id          = module.vpc.vpc_id
    vpc_cidr        = module.vpc.vpc_cidr
    private_subnets = module.vpc.private_subnets_ids
    public_subnets  = module.vpc.public_subnets_ids
    user_data       = data.template_file.web_server_ud.rendered
    key_name        = var.key_name
    ami             = var.ami
    my_ips          = var.my_ips
    instance_type   = var.instance_type
}

locals {
  s3_origin_id = "ice-cream-static-site"
  api_origin_id = "nginx-api"
}

resource "aws_cloudfront_origin_access_identity" "cdn" {
  comment = local.s3_origin_id
}

module "static_site" {
  source = "./modules/static_site"

  src = "/Users/isagues/facu/redes/terraform-demo/ice-cream"
  bucket_access_OAI = [aws_cloudfront_origin_access_identity.cdn.iam_arn]
}

resource "aws_secretsmanager_secret" "example" {
  name = "example"
}

resource "aws_secretsmanager_secret" "secret_example" {
  name = "secret_example"
}

resource "aws_secretsmanager_secret_version" "example" {
  secret_id     = aws_secretsmanager_secret.example.id
  secret_string = "example-string-to-protect-"
}

resource "aws_secretsmanager_secret_version" "secret_example" {
  secret_id     = aws_secretsmanager_secret.secret_example.id
  secret_string = var.secret
}

# data "aws_acm_certificate" "redes" {
#   domain      = var.domain_name
#   statuses    = ["ISSUED"]
#   types       = ["AMAZON_ISSUED"]
#   most_recent = true
# }


module "cdn" {
  source = "./modules/cdn"

  OAI                   = aws_cloudfront_origin_access_identity.cdn
  s3_origin_id          = local.s3_origin_id
  api_origin_id         = local.api_origin_id
  api_domain_name       = module.web_server.domain_name
  bucket_domain_name    = module.static_site.domain_name
  domain_names          = var.domain_names
  # certificate_arn = data.aws_acm_certificate.arn
}