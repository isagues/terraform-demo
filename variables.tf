variable key_name {}
variable key_path {}
variable ami {}
variable my_ips {}
variable instance_type {}
variable cidr_block {}
variable zones_count {}
variable web_server_ud_path {}
variable base_domain {type = string}
variable app_name {type = string}
variable ss_src           {type = string}

# AWS
variable aws_region       {type = string}

# GCP
variable gcp_project      {type = string}
variable gcp_region       {type = string}
variable bucket_region    {type = string}
variable gcp_default_zone {type = string}
variable gcp_user         {type = string}