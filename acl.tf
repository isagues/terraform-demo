resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.vpc.default_network_acl_id

  tags = {
    Name = "default_nacl"
  }
  # no rules defined, deny all traffic in this ACL
}
###
## Public
###
resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "public_nacl"
  }
}

resource "aws_network_acl_rule" "public_out" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 100
  egress         = true
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_in" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 150
  egress         = false
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_association" "public_subnet_1_nacl_assoc" {
  network_acl_id = aws_network_acl.public_nacl.id
  subnet_id      = aws_subnet.public_1.id
}

resource "aws_network_acl_association" "public_subnet_2_nacl_assoc" {
  network_acl_id = aws_network_acl.public_nacl.id
  subnet_id      = aws_subnet.public_2.id
}

###
## Private
###
resource "aws_network_acl" "private_nacl" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "private_nacl"
  }
}

resource "aws_network_acl_rule" "private_out" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 100
  egress         = true
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private_in_ssh" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 100
  egress         = false
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_association" "private_subnet_1_nacl_assoc" {
  network_acl_id = aws_network_acl.private_nacl.id
  subnet_id      = aws_subnet.private_1.id
}

resource "aws_network_acl_association" "private_subnet_2_nacl_assoc" {
  network_acl_id = aws_network_acl.private_nacl.id
  subnet_id      = aws_subnet.private_2.id
}
