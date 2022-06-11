###
## Public
###
# Declaro tabla de ruteo
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "public_rt"
  }
}

# Agrego rutas
resource "aws_route" "public_rt_ig" {
  route_table_id            = aws_route_table.public_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.igw.id
}

# La bindeo a la subnet
resource "aws_route_table_association" "public_1_rt_assoc" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_route_table_association" "public_2_rt_assoc" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}

###
## Private
###

resource "aws_route_table" "private_1_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "private_1_rt"
  }
}

resource "aws_route" "private_1_rt_natgw" {
  route_table_id            = aws_route_table.private_1_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_nat_gateway.natgw_1.id
}

resource "aws_route_table_association" "private_1_rt_assoc" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_1_rt.id
}

resource "aws_route_table" "private_2_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "private_2_rt"
  }
}

resource "aws_route" "private_2_rt_natgw" {
  route_table_id            = aws_route_table.private_2_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_nat_gateway.natgw_2.id
}

resource "aws_route_table_association" "private_2_rt_assoc" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_2_rt.id
}

