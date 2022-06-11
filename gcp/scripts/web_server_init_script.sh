#!/bin/bash
apt update -y
apt install -y nginx
systemctl start nginx
systemctl enable nginx
wget -O /etc/nginx/conf.d/api.conf https://raw.githubusercontent.com/isagues/terraform-demo/main/scripts/api.conf
systemctl reload nginx