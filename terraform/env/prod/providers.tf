terraform {
  backend "s3" {
    bucket = "ecs-remote-backend-bucket-prod"
    key    = "state.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  region = "us-west-1"
}