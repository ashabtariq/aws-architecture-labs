terraform {
  required_version = ">= 1.6.0"

  # Optional: remote state backend (S3 + DynamoDB)
  # backend "s3" {
  #   bucket = "my-terraform-state-bucket"
  #   key    = "securitylab/terraform.tfstate"
  #   region = "us-east-1"
  # }
}

provider "aws" {
  region = var.aws_region
}
