
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

resource "random_id" "version" {
  keepers = {
    service_hash = local.service_file_hash
  }

  byte_length = 8
}