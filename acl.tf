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

# resource "aws_network_acl_rule" "public_in_ssh" {
#   network_acl_id = aws_network_acl.public_nacl.id
#   rule_number    = 100
#   egress         = false
#   from_port      = 22
#   to_port        = 22
#   protocol       = "tcp"
#   rule_action    = "allow"
#   cidr_block     = "200.123.140.195/32"
# }

# resource "aws_network_acl_rule" "public_in_https" {
#   network_acl_id = aws_network_acl.public_nacl.id
#   rule_number    = 200
#   egress         = false
#   from_port      = 443
#   to_port        = 443
#   protocol       = "tcp"
#   rule_action    = "allow"
#   cidr_block     = "0.0.0.0/0"
# }

# resource "aws_network_acl_rule" "public_in_http" {
#   network_acl_id = aws_network_acl.public_nacl.id
#   rule_number    = 300
#   egress         = false
#   from_port      = 80
#   to_port        = 80
#   protocol       = "tcp"
#   rule_action    = "allow"
#   cidr_block     = "0.0.0.0/0"
# }

# resource "aws_network_acl_rule" "public_in_icmp" {
#   network_acl_id = aws_network_acl.public_nacl.id
#   rule_number    = 400
#   egress         = false
#   from_port      = 0
#   to_port        = 30
#   protocol       = "icmp"
#   rule_action    = "allow"
#   cidr_block     = "0.0.0.0/0"
# }

# # TODO: como se maneja esto?
# resource "aws_network_acl_rule" "public_in_nat" {
#   network_acl_id = aws_network_acl.public_nacl.id
#   rule_number    = 500
#   egress         = false
#   from_port      = 1024
#   to_port        = 65535
#   protocol       = "tcp"
#   rule_action    = "allow"
#   cidr_block     = "0.0.0.0/0"
# }

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
#   cidr_block     = aws_vpc.vpc.cidr_block
}

resource "aws_network_acl_rule" "private_in_ssh" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 100
  egress         = false
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
#   cidr_block     = aws_vpc.vpc.cidr_block
}

resource "aws_network_acl_association" "private_subnet_1_nacl_assoc" {
  network_acl_id = aws_network_acl.private_nacl.id
  subnet_id      = aws_subnet.private_1.id
}

resource "aws_network_acl_association" "private_subnet_2_nacl_assoc" {
  network_acl_id = aws_network_acl.private_nacl.id
  subnet_id      = aws_subnet.private_2.id
}
