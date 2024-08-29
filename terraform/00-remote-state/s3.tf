data "aws_caller_identity" "current" {}

# bucket s3 para o remote state
resource "aws_s3_bucket" "remote_state" {
    bucket = "terraform-state-2024-${data.aws_caller_identity.current.account_id}"
}

# versionamento do bucker s3 
resource "aws_s3_bucket_versioning" "remote_state" {
    bucket = aws_s3_bucket.remote_state.id 
    versioning_configuration {
      status = "Enabled"
    }
  
}