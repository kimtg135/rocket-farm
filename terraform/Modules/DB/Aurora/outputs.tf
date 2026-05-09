output "cluster_id" {
  description = "The ID of the Aurora cluster"
  value       = aws_rds_cluster.db_cluster.id
}

output "cluster_arn" {
  description = "The ARN of the Aurora cluster"
  value       = aws_rds_cluster.db_cluster.arn
}

output "cluster_endpoint" {
  description = "The cluster endpoint"
  value       = aws_rds_cluster.db_cluster.endpoint
}

output "cluster_reader_endpoint" {
  description = "The cluster reader endpoint"
  value       = aws_rds_cluster.db_cluster.reader_endpoint
}

output "db_security_group_id" {
  description = "Security group ID of the database"
  value       = aws_security_group.db.id
}

output "db_subnet_group_name" {
  description = "The name of the DB subnet group"
  value       = aws_db_subnet_group.db_subnet_group.name
}

output "global_cluster_id" {
  description = "The ID of the Aurora Global Cluster"
  value       = var.create_global_cluster ? aws_rds_global_cluster.db_global_cluster[0].id : var.global_cluster_id
}

output "db_secret_arn" {
  description = "The ARN of the DB credentials secret"
  value       = data.aws_secretsmanager_secret.db_credentials.arn
}
