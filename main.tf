terraform {
  required_version = "~> 1.2.0"

  backend "s3" {
    bucket = "state20220612210353297300000001"
    key    = "state"
    region = "us-east-1"
    encrypt = true
    kms_key_id = "709da914-a6a3-407d-bddb-50b5309189b5"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.18.0"
    }

    google = {
      source = "hashicorp/google"
      version = "~> 4.24.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "google" {
  project = local.gcp_project
  region  = local.gcp_region
  zone    = local.gcp_default_zone
}

module gcp {
  source = "./gcp"
}

module "certificate" {
  source = "./aws/modules/certificate"

  base_domain   = var.base_domain
  app_subdomain = var.app_name
}

module "vpc" {
    source = "./aws/modules/vpc"

    cidr_block  = var.cidr_block
    zones_count = var.zones_count
    natgw       = true
}

resource "aws_key_pair" "redes_key" {
  key_name   = var.key_name
  public_key = file(var.key_path)
}

module "bastion" {
    source = "./aws/modules/bastion"

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
    source = "./aws/modules/web_server"

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
  source = "./aws/modules/static_site"

  src = var.ss_src
  bucket_access_OAI = [aws_cloudfront_origin_access_identity.cdn.iam_arn]
}

module "cdn" {
  source = "./aws/modules/cdn"

  OAI                   = aws_cloudfront_origin_access_identity.cdn
  s3_origin_id          = local.s3_origin_id
  api_origin_id         = local.api_origin_id
  api_domain_name       = module.web_server.domain_name
  bucket_domain_name    = module.static_site.domain_name
  aliases               = ["www.${local.app_domain}", local.app_domain, local.pri_deploy_domain]
  certificate_arn       = module.certificate.arn
}

module "dns" {
  source = "./aws/modules/dns"

  base_domain                   = var.base_domain
  app_subdomain                 = var.app_name
  primary_subdomain             = local.pri_app_deploy
  secondary_subdomain           = local.sec_app_deploy
  app_primary_health_check_path = "/api/time"
  pri_deploy_cloudfront         = module.cdn.cloudfront_distribution
  sec_deploy_name_servers       = module.gcp.gcp_dns_name_servers
}

