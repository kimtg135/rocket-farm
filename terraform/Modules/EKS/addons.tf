# 1. addon-version check
data "aws_eks_addon_version" "coredns" {
  addon_name         = "coredns"
  kubernetes_version = var.kubernetes_version
  most_recent        = true
}

data "aws_eks_addon_version" "kube_proxy" {
  addon_name         = "kube-proxy"
  kubernetes_version = var.kubernetes_version
  most_recent        = true
}

data "aws_eks_addon_version" "vpc_cni" {
  addon_name         = "vpc-cni"
  kubernetes_version = var.kubernetes_version
  most_recent        = true
}

resource "aws_eks_addon" "coredns" {
  cluster_name                = aws_eks_cluster.eks_cluster.name
  addon_name                  = "coredns"
  addon_version               = data.aws_eks_addon_version.coredns.version
  resolve_conflicts_on_create = var.addon_resolve_conflicts
  resolve_conflicts_on_update = var.addon_resolve_conflicts
  depends_on                  = [aws_eks_cluster.eks_cluster]

  lifecycle {
    ignore_changes = [addon_version]
  }
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name                = aws_eks_cluster.eks_cluster.name
  addon_name                  = "kube-proxy"
  addon_version               = data.aws_eks_addon_version.kube_proxy.version
  resolve_conflicts_on_create = var.addon_resolve_conflicts
  resolve_conflicts_on_update = var.addon_resolve_conflicts
  depends_on                  = [aws_eks_cluster.eks_cluster]

  lifecycle {
    ignore_changes = [addon_version]
  }
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = aws_eks_cluster.eks_cluster.name
  addon_name                  = "vpc-cni"
  addon_version               = data.aws_eks_addon_version.vpc_cni.version
  service_account_role_arn    = aws_iam_role.vpc_cni.arn
  resolve_conflicts_on_create = var.addon_resolve_conflicts
  resolve_conflicts_on_update = var.addon_resolve_conflicts
  depends_on                  = [aws_eks_cluster.eks_cluster]

  lifecycle {
    ignore_changes = [addon_version]
  }
}
