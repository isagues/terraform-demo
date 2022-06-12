###
# Bastion Security Group
##
resource "aws_security_group" "bastion" {

  name   = "bastion"
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "bastion"
  }
}

resource "aws_security_group_rule" "bastion_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "bastion_in_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = local.my_ips
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "bastion_in_icmp" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}

###
# Web server Security Group
##
resource "aws_security_group" "web" {
  name   = "web"
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "web"
  }
}

resource "aws_security_group_rule" "web_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web.id
}

resource "aws_security_group_rule" "web_in_icmp" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = [aws_vpc.vpc.cidr_block]
  security_group_id = aws_security_group.web.id
}

resource "aws_security_group_rule" "web_in_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.vpc.cidr_block]
  security_group_id = aws_security_group.web.id
}

resource "aws_security_group_rule" "web_in_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.vpc.cidr_block]
  security_group_id = aws_security_group.web.id
}

resource "aws_security_group_rule" "web_in_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.vpc.cidr_block]
  security_group_id = aws_security_group.web.id
}

resource "aws_security_group" "web_lb" {
  name   = "web_lb"
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "web_lb"
  }
}

resource "aws_security_group_rule" "web_lb_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_lb.id
}

resource "aws_security_group_rule" "web_lb_in_icmp" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_lb.id
}

resource "aws_security_group_rule" "web_lb_in_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.vpc.cidr_block]
  security_group_id = aws_security_group.web_lb.id
}

resource "aws_security_group_rule" "web_lb_in_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_lb.id
}
