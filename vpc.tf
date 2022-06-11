resource "aws_vpc" "vpc" {
  # name                  = "pipo-redes-vpc"
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true" #gives you an internal domain name
  enable_dns_hostnames = "true" #gives you an internal host name
  enable_classiclink   = "false"
  instance_tenancy     = "default"

  tags = {
    Name = "vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "igw"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  #   map_public_ip_on_launch = "true" //it makes this a public subnet
  availability_zone = data.aws_availability_zones.available.names[0] # primer AZ disponible

  tags = {
    Name = "public_1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.11.0/24"
  #   map_public_ip_on_launch = "true" //it makes this a public subnet
  availability_zone = data.aws_availability_zones.available.names[1] # primer AZ disponible

  tags = {
    Name = "public_2"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  #   map_public_ip_on_launch = "true" //it makes this a public subnet
  availability_zone = data.aws_availability_zones.available.names[0] # primer AZ disponible

  tags = {
    Name = "private_1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.12.0/24"
  #   map_public_ip_on_launch = "true" //it makes this a public subnet
  availability_zone = data.aws_availability_zones.available.names[1] # primer AZ disponible

  tags = {
    Name = "private_2"
  }
}


