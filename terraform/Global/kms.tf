# Seoul ECR KMS Key
resource "aws_kms_key" "ecr_seoul" {
  provider            = aws.seoul
  description         = "KMS key for ECR image encryption (Seoul)"
  enable_key_rotation = true

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "ecr-kms-key-policy-seoul"
    Statement = [
      {
        Sid    = "EnableRootAccountFullAccess"
        Effect = "Allow"
        Principal = {
          AWS = var.admin_iam_principal
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "AllowECRServiceAccess"
        Effect = "Allow"
        Principal = {
          Service = "ecr.amazonaws.com"
        }
        Action = [
          "kms:GenerateDataKey*",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:CreateGrant",
          "kms:ReEncrypt*"
        ]
        Resource = "*"
      }
    ]
  })

  tags = { Name = "${var.project_name}-${var.regions.main}-ecr" }
}

resource "aws_kms_alias" "ecr_seoul" {
  provider      = aws.seoul
  name          = "alias/${var.project_name}-ecr"
  target_key_id = aws_kms_key.ecr_seoul.key_id
}

# Tokyo ECR KMS Key
resource "aws_kms_key" "ecr_tokyo" {
  provider            = aws.tokyo
  description         = "KMS key for ECR image encryption (Tokyo)"
  enable_key_rotation = true

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "ecr-kms-key-policy-tokyo"
    Statement = [
      {
        Sid    = "EnableRootAccountFullAccess"
        Effect = "Allow"
        Principal = {
          AWS = var.admin_iam_principal
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "AllowECRServiceAccess"
        Effect = "Allow"
        Principal = {
          Service = "ecr.amazonaws.com"
        }
        Action = [
          "kms:GenerateDataKey*",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:CreateGrant",
          "kms:ReEncrypt*"
        ]
        Resource = "*"
      }
    ]
  })

  tags = { Name = "${var.project_name}-${var.regions.dr}-ecr" }
}

resource "aws_kms_alias" "ecr_tokyo" {
  provider      = aws.tokyo
  name          = "alias/${var.project_name}-ecr"
  target_key_id = aws_kms_key.ecr_tokyo.key_id
}