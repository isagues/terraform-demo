locals {
  pri_app_deploy    = "aws"
  sec_app_deploy    = "gcp"

  app_domain        = "${var.app_name}.${var.base_domain}"
  pri_deploy_domain = "${local.pri_app_deploy}.${var.base_domain}"
  sec_deploy_domain = "${local.sec_app_deploy}.${var.base_domain}"
}