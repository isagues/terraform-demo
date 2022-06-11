terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 4.18.0"
   }
 }

 required_version = "~> 1.2.0"
}

provider "aws" {
  region = local.aws_region
}

# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}
