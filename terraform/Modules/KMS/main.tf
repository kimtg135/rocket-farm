data "aws_caller_identity" "current" {}


# EKS
resource "aws_kms_key" "eks" {
  description         = "KMS key for EKS cluster secret encryption"
  enable_key_rotation = true

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "eks-kms-key-policy"
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
        Sid       = "AllowEKSClusterRole"
        Effect    = "Allow"
        Principal = { AWS = "*" }
        Action = [
          "kms:Encrypt", "kms:Decrypt", "kms:ReEncrypt*",
          "kms:GenerateDataKey*", "kms:DescribeKey"
        ]
        Resource = "*"
        Condition = {
          ArnLike = {
            "aws:PrincipalArn" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.eks_cluster_name}-cluster-role"
          }
        }
      },
      {
        Sid       = "AllowNodeIAMRole"
        Effect    = "Allow"
        Principal = { AWS = "*" }
        Action = [
          "kms:Encrypt", "kms:Decrypt", "kms:ReEncrypt*",
          "kms:GenerateDataKey*", "kms:DescribeKey", "kms:CreateGrant"
        ]
        Resource = "*"
        Condition = {
          ArnLike = {
            "aws:PrincipalArn" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.eks_cluster_name}-node-role"
          }
        }
      },
      {
        Sid       = "AllowEC2ServiceEBSAccess"
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action = [
          "kms:Decrypt", "kms:GenerateDataKeyWithoutPlainText",
          "kms:CreateGrant", "kms:DescribeKey"
        ]
        Resource = "*"
        Condition = {
          Bool = { "kms:GrantIsForAWSResource" = "true" }
        }
      },
      {
        Sid       = "AllowAutoScalingService"
        Effect    = "Allow"
        Principal = { AWS = "*" }
        Action = [
          "kms:Encrypt", "kms:Decrypt", "kms:ReEncrypt*",
          "kms:GenerateDataKey*", "kms:DescribeKey", "kms:CreateGrant"
        ]
        Resource = "*"
        Condition = {
          ArnLike = {
            "aws:PrincipalArn" = [
              "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
              "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.eks_cluster_name}-karpenter-controller"
            ]
          }
        }
      }
    ]
  })

  tags = merge(var.common_tags, { Name = "${var.eks_cluster_name}-${var.region_role}-kms" })
}

resource "aws_kms_alias" "eks" {
  name          = "alias/${var.eks_cluster_name}-${var.region_role}-kms"
  target_key_id = aws_kms_key.eks.key_id
}

# RDS Aurora 
resource "aws_kms_key" "aurora" {
  description             = "RDS Aurora encryption key"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "EnableAdminAccess"
        Effect    = "Allow"
        Principal = { AWS = var.admin_iam_principal }
        Action    = "kms:*"
        Resource  = "*"
      },
      {
        Sid       = "AllowRDSServiceAccess"
        Effect    = "Allow"
        Principal = { Service = "rds.amazonaws.com" }
        Action    = ["kms:GenerateDataKey*", "kms:Decrypt", "kms:DescribeKey", "kms:CreateGrant", "kms:ReEncrypt*"]
        Resource  = "*"
      }
    ]
  })

  tags = merge(var.common_tags, { Name = "${var.project_name}-${var.region_role}-aurora-kms" })
}


resource "aws_kms_alias" "aurora" {
  name          = "alias/${var.project_name}-${var.region_role}-aurora"
  target_key_id = aws_kms_key.aurora.key_id
}

# ElastiCache Redis
resource "aws_kms_key" "redis" {
  description             = "Redis encryption key"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "EnableAdminAccess"
        Effect    = "Allow"
        Principal = { AWS = var.admin_iam_principal }
        Action    = "kms:*"
        Resource  = "*"
      },
      {
        Sid       = "AllowElastiCacheServiceAccess"
        Effect    = "Allow"
        Principal = { Service = "elasticache.amazonaws.com" }
        Action    = ["kms:GenerateDataKey*", "kms:Decrypt", "kms:DescribeKey", "kms:CreateGrant"]
        Resource  = "*"
      }
    ]
  })

  tags = merge(var.common_tags, { Name = "${var.project_name}-${var.region_role}-redis-kms" })
}

resource "aws_kms_alias" "redis" {
  name          = "alias/${var.project_name}-${var.region_role}-redis"
  target_key_id = aws_kms_key.redis.key_id
}