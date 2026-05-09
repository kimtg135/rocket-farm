# ECR Private 리포지토리 - Seoul (Main)
resource "aws_ecr_repository" "main" {
  provider             = aws.seoul
  for_each             = toset(var.ecr_repositories)
  name                 = each.value
  image_tag_mutability = "MUTABLE"
  force_delete         = false

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = aws_kms_key.ecr_seoul.arn
  }

  tags = { Name = "${each.value}-main" }
}

# ECR Private 리포지토리 - Tokyo (DR)
resource "aws_ecr_repository" "dr" {
  provider             = aws.tokyo
  for_each             = toset(var.ecr_repositories)
  name                 = each.value
  image_tag_mutability = "MUTABLE"
  force_delete         = false

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = aws_kms_key.ecr_tokyo.arn
  }

  tags = { Name = "${each.value}-dr" }
}

# ECR 라이프사이클 정책
resource "aws_ecr_lifecycle_policy" "main" {
  provider   = aws.seoul
  for_each   = aws_ecr_repository.main
  repository = each.value.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images after 7 days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 7
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Keep only last 30 tagged images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v", "release", "main", "dev"]
          countType     = "imageCountMoreThan"
          countNumber   = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

resource "aws_ecr_lifecycle_policy" "dr" {
  provider   = aws.tokyo
  for_each   = aws_ecr_repository.dr
  repository = each.value.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images after 7 days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 7
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Keep only last 30 tagged images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v", "release", "main", "dev"]
          countType     = "imageCountMoreThan"
          countNumber   = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}


# ECR 레플리케이션 설정 (서울 → 도쿄 DR)
resource "aws_ecr_replication_configuration" "dr" {
  provider = aws.seoul

  replication_configuration {
    rule {
      destination {
        region      = var.regions.dr
        registry_id = data.aws_caller_identity.current.account_id
      }

      repository_filter {
        filter      = "${var.project_name}/"
        filter_type = "PREFIX_MATCH"
      }
    }
  }
}
