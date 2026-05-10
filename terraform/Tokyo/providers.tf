# 공통 리소스(S3, ECR 등)의 정보를 가져오기 위해 Global의 상태를 참조함.
data "terraform_remote_state" "global" {
  backend = "s3"
  config = {
    bucket = "BUCKET_NAME"
    key    = "global/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

# Terraform 버전, 상태 저장소, 프로바이더 요구사항을 정의.
terraform {
  required_version = ">= 1.7"

  # Terraform 상태 파일을 저장할 S3 백엔드를 설정.
  backend "s3" {
    bucket       = "rocketfarm-tfstate-tokyo"
    key          = "Tokyo/terraform.tfstate"
    region       = "ap-northeast-1"
    encrypt      = true
    use_lockfile = true
  }

  # 이 구성에서 사용할 Terraform 프로바이더를 지정.
  required_providers {
    # AWS 리소스 생성을 위한 기본 프로바이더.
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    # OIDC 인증서 조회를 위한 TLS 프로바이더.
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }

    # 대기 시간을 위한 time 프로바이더.
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }

  }
}

# 도쿄 리전에 배포할 AWS 기본 프로바이더를 설정함.
provider "aws" {
  region = var.aws_region

  # 모든 리소스에 공통 태그를 자동으로 적용함.
  default_tags {
    tags = var.common_tags
  }
}
