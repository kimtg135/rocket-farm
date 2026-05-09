terraform {
  required_version = ">= 1.7"

  backend "s3" {
    bucket       = "BUCKET_NAME"
    key          = "global/terraform.tfstate"
    region       = "ap-northeast-2"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  alias  = "seoul"
  region = var.regions.main

  default_tags {
    tags = var.common_tags
  }
}

provider "aws" {
  alias  = "tokyo"
  region = var.regions.dr

  default_tags {
    tags = var.common_tags
  }
}

data "aws_caller_identity" "current" {
  provider = aws.seoul
}