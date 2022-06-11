resource "aws_instance" "bastion_1" {
  ami                         = "ami-0022f774911c1d690"
  key_name                    = "redes_key"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_1.id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true

  tags = {
    Name = "bastion_1"
  }
}
resource "aws_instance" "bastion_2" {
  ami                         = "ami-0022f774911c1d690"
  key_name                    = "redes_key"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_2.id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true

  tags = {
    Name = "bastion_2"
  }
}

resource "aws_key_pair" "redes_key" {
  key_name   = "redes_key"
  public_key = file("~/.ssh/awsacademy_eed25519.pub")
}