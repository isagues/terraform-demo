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

module "static_site" {
  source = "./modules/static_site"

  src = "/Users/isagues/facu/redes/terraform-demo/ice-cream"
  
}