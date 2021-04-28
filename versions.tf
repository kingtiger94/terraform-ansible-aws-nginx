# Lookup to server state
terraform {
  backend "s3" {
    bucket  = "avg-server-state"
    key     = "AVG/create_ec2+nginx/terraform.tfstate"
    region  = "us-east-2"
    encrypt = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}
