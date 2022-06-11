data "template_file" "web_server_ud" {
  template = file("scripts/web_server_user_data.sh")
}

resource "aws_instance" "web_server_1" {
  ami                       = "ami-0022f774911c1d690"
  instance_type             = "t2.micro"
  key_name                  = "redes_key"
  subnet_id                 = aws_subnet.private_1.id
  user_data                 = data.template_file.web_server_ud.rendered
  vpc_security_group_ids    = [aws_security_group.web.id]

  tags = {
    Name = "web_server_1"
  }
}

resource "aws_instance" "web_server_2" {
  ami                       = "ami-0022f774911c1d690"
  instance_type             = "t2.micro"
  key_name                  = "redes_key"
  subnet_id                 = aws_subnet.private_2.id
  user_data                 = data.template_file.web_server_ud.rendered
  vpc_security_group_ids    = [aws_security_group.web.id]

  tags = {
    Name = "web_server_2"
  }
}

# resource "aws_instance" "web1" {
#   ami                    = lookup(var.AMI, var.AWS_REGION)
#   instance_type          = "t2.micro"                               # VPC
#   subnet_id              = aws_subnet.public_1.id       # Security Group
#   vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"] # the Public SSH key
#   key_name               = aws_key_pair.london-region-key-pair.id   # nginx installation

#   provisioner "file" {
#     source      = "nginx.sh"
#     destination = "/tmp/nginx.sh"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "chmod +x /tmp/nginx.sh",
#       "sudo /tmp/nginx.sh"
#     ]
#   }
#   connection {
#     user        = var.EC2_USER
#     private_key = file("${var.PRIVATE_KEY_PATH}")
#   }
# } // Sends your public key to the instance

# resource "aws_key_pair" "london-region-key-pair" {
#   key_name   = "london-region-key-pair"
#   public_key = file(var.PUBLIC_KEY_PATH)
# }