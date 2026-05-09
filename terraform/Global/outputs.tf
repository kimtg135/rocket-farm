# ECR
output "ecr_repository_urls_main" {
  description = "ECR repository URL(Seoul)"
  value       = { for k, v in aws_ecr_repository.main : k => v.repository_url }
}

output "ecr_repository_urls_dr" {
  description = "ECR repository URL(Tokyo)"
  value       = { for k, v in aws_ecr_repository.dr : k => v.repository_url }
}

output "ecr_repository_arns_main" {
  description = "ECR repository ARN (Seoul)"
  value       = { for k, v in aws_ecr_repository.main : k => v.arn }
}

output "ecr_repository_arns_dr" {
  description = "ECR repository ARN (Tokyo)"
  value       = { for k, v in aws_ecr_repository.dr : k => v.arn }
}