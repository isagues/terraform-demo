#!/bin/bash
yum update -y
amazon-linux-extras install -y nginx1
wget https://raw.githubusercontent.com/isagues/terraform-demo/main/scripts/api.conf
systemctl start nginx
systemctl enable nginx