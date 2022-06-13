provider "aws" {
  region = "us-east-1"
}

module "vpc" {
    source = "../aws/modules/vpc"

    cidr_block = "10.0.0.0/16"
    zones_count = 3
}

# resource "aws_key_pair" "redes_key" {
#   key_name   = "key"
#   public_key = file("C:/Users/faust/.ssh/id_rsa.pub")
# }

# module "bastion" {
#     source = "../aws/modules/bastion"

#     vpc_id        = module.vpc.vpc_id
#     subnets       = module.vpc.public_subnets_ids
#     key_name      = "key"
#     ami           = "ami-0022f774911c1d690"
#     my_ips        = ["200.123.140.195/32", "181.29.41.98/32"]
#     instance_type = "t2.micro"
# }