resource "aws_cloudwatch_log_group" "eks_cluster_logs" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 30
  tags              = var.common_tags
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids              = var.subnet_ids
    security_group_ids      = [aws_security_group.eks_cluster.id]
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  access_config {
    authentication_mode = "API"
  }

  encryption_config {
    provider {
      key_arn = var.kms_key_arn
    }
    resources = ["secrets"]
  }

  enabled_cluster_log_types = var.cluster_log_types

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_cluster_vpc_resource_controller,
    aws_cloudwatch_log_group.eks_cluster_logs
  ]

  tags = merge(var.common_tags, {
    Name = "${var.cluster_name}-cluster"
  })
}
