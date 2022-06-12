key_name            = "redes_key"
key_path            = "~/.ssh/awsacademy_eed25519.pub"
ami                 = "ami-0022f774911c1d690"
my_ips              = ["200.123.140.195/32", "181.29.41.98/32"]
instance_type       = "t2.micro"
cidr_block          = "10.0.0.0/16"
zones_count         = 3
web_server_ud_path  = "scripts/web_server_user_data.sh"