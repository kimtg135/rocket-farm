output "replication_group_id" {
  description = "The ID of the ElastiCache replication group"
  value       = "${var.project_name}-${var.region_role}-redis"
}

output "primary_endpoint_address" {
  description = "The address of the endpoint for the primary node in the replication group"
  value       = aws_elasticache_replication_group.redis_replication_group.primary_endpoint_address
}

output "reader_endpoint_address" {
  description = "The address of the endpoint for the reader node in the replication group"
  value       = aws_elasticache_replication_group.redis_replication_group.reader_endpoint_address
}

output "member_clusters" {
  description = "The identifiers of the cache clusters that are members of this replication group"
  value       = aws_elasticache_replication_group.redis_replication_group.member_clusters
}

output "redis_security_group_id" {
  description = "Security group ID of the Redis cluster"
  value       = aws_security_group.redis_sg.id
}

output "redis_subnet_group_name" {
  description = "The name of the Redis subnet group"
  value       = aws_elasticache_subnet_group.redis_subnet_group.name
}
