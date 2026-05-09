# Current executing principal
resource "aws_eks_access_entry" "current_user" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  principal_arn = data.aws_caller_identity.current.arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "current_user" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  principal_arn = aws_eks_access_entry.current_user.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}

# Wait for RBAC propagation
resource "time_sleep" "wait_for_rbac" {
  depends_on      = [aws_eks_access_policy_association.current_user]
  create_duration = "30s"
}

# Admin Role access
resource "aws_eks_access_entry" "admin" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  principal_arn = aws_iam_role.eks_admin.arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "admin" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  principal_arn = aws_eks_access_entry.admin.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}

# Node access entry (for Karpenter, etc.)
resource "aws_eks_access_entry" "nodes" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  principal_arn = aws_iam_role.node.arn
  type          = var.node_access_entry_type
}
