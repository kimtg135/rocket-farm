output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.name
}

output "cluster_id" {
  description = "The ID of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.id
}

output "cluster_arn" {
  description = "The ARN of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.arn
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster API server"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_certificate_authority_data" {
  description = "The base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
}

output "node_security_group_id" {
  description = "Security group ID attached to the EKS nodes"
  value       = aws_security_group.nodes.id
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider"
  value       = aws_iam_openid_connect_provider.eks_oidc_provider.arn
}

output "oidc_provider_url" {
  description = "The URL of the OIDC Provider"
  value       = aws_iam_openid_connect_provider.eks_oidc_provider.url
}

output "node_role_arn" {
  description = "The ARN of the IAM role for the EKS nodes"
  value       = aws_iam_role.node.arn
}
