locals {
  my_ips            = ["200.123.140.195/32", "181.29.41.98/32"]

  aws_region        = "us-east-1"

  root_domain       = "tobiasbrandy.com"
  base_domain       = "redes.${local.root_domain}"
  demo_domain       = "demo.${local.base_domain}"
  demo_aws_domain   = "aws.${local.base_domain}"
  demo_gcp_domain   = "gcp.${local.base_domain}"

  key_file          = "~/.ssh/id_rsa.pub"
}