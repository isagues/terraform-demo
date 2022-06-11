resource "aws_nat_gateway" "natgw_1" {
  allocation_id = aws_eip.natgw_1_eip.id
  subnet_id     = aws_subnet.public_1.id

  tags = {
    Name = "natgw_1"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "natgw_2" {
  allocation_id = aws_eip.natgw_2_eip.id
  subnet_id     = aws_subnet.public_2.id

  tags = {
    Name = "natgw_2"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}