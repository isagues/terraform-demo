key_name            = "redes_key"
key_path            = "~/.ssh/id_rsa.pub"
ami                 = "ami-0022f774911c1d690"
my_ips              = ["200.123.140.195/32", "181.29.41.98/32"]
instance_type       = "t2.micro"
cidr_block          = "10.0.0.0/16"
zones_count         = 3
web_server_ud_path  = "scripts/web_server_user_data.sh"
base_domain         = "redes.tobiasbrandy.com"
app_name            = "demo"

# AWS
aws_region          = "us-east-1"

# GCP
  gcp_project       = "redes-demo-2022-353122"
  gcp_region        = "us-east1"
  bucket_region     = "US-EAST1"
  ss_src            = "ice-cream"
  gcp_default_zone  = "us-east1-a"
  gcp_user          = "user:tbrandy@itba.edu.ar"