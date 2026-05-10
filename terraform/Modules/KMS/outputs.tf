output "eks_kms_key_arn" {
  description = "EKS KMS Key ARN"
  value       = aws_kms_key.eks.arn
}

output "eks_kms_key_id" {
  description = "EKS KMS Key ID"
  value       = aws_kms_key.eks.key_id
}

output "eks_kms_alias_name" {
  description = "EKS KMS Alias Name"
  value       = aws_kms_alias.eks.name
}

output "aurora_kms_key_arn" {
  description = "Aurora KMS Key ARN"
  value       = aws_kms_key.aurora.arn
}

output "redis_kms_key_arn" {
  description = "Redis KMS Key ARN"
  value       = aws_kms_key.redis.arn
}