terraform {
    required_version = "~> 1.7"

    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 5.50"
      }
    }

# backend see path /config/dev/backend.tf
    backend "s3" { 
    }
}