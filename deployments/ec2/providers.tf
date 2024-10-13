terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region                   = "eu-central-1"         # Frankfurt region
  shared_credentials_files = ["~/.aws/credentials"] # Path to AWS credentials file
  profile                  = "bohuang-admin"        # Specify the profile to use from the credentials file
}