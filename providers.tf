terraform {
  cloud {
    organization = "tf-class-september-20"

    workspaces {
      name = "lab-oct-16"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}