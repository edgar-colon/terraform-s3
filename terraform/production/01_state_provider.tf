terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  /* backend "s3" {
    bucket  = "terraform-state-banpay"
    encrypt = true
    key     = "terraform.tfstate"
    region  = "us-east-1"
  } */
}

provider "aws" {
  region                      = var.aws_region
  access_key                  = "test123"
  secret_key                  = "testabc"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true

  endpoints {
    s3 = "http://s3.localhost.localstack.cloud:4566"
  }
}
