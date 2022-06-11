# resource "aws_kms_key" "terraform_state" {
#   description             = "This key is used to encrypt terraform state"
#   deletion_window_in_days = 10
#   enable_key_rotation     = true
# }

# resource "aws_kms_alias" "key_alias" {
#   name          = "alias/terraform-bucket-key"
#   target_key_id = aws_kms_key.terraform-bucket-key.key_id
# }

# resource "aws_s3_bucket" "terraform_state" {
#   bucket = "terraform-state"
#   acl    = "private"

#   versioning {
#       enabled = true
#   }

#   server_side_encryption_configuration {
#     rule {
#       apply_server_side_encryption_by_default {
#         kms_master_key_id = aws_kms_key.terraform-bucket-key.arn
#         sse_algorithm     = "aws:kms"
#       }
#     }
#   }
# }

# resource "aws_dynamodb_table" "terraform_state" {
#   name           = "terraform-state"
#   read_capacity  = 20
#   write_capacity = 20
#   hash_key       = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }


# resource "aws_s3_bucket_public_access_block" "block" {
#   bucket = aws_s3_bucket.terraform-state.id

#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }

# terraform {
#   backend "s3" {
#     bucket         = "terraform-state"
#     key            = "state/terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     kms_key_id     = "alias/terraform-bucket-key"
#     dynamodb_table = "terraform-state"
#   }
# }