# ElastiCache Subnet Group
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "${var.project_name}-${var.region_role}-redis-subnet"
  subnet_ids = var.subnet_ids

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.region_role}-redis-subnet"
  })
}

# ElastiCache Parameter Group
resource "aws_elasticache_parameter_group" "redis_parameter_group" {
  name   = "${var.project_name}-${var.region_role}-redis-pg"
  family = var.redis_parameter_group_family

  parameter {
    name  = "maxmemory-policy"
    value = var.redis_maxmemory_policy
  }
}

# ElastiCache Redis Replication Group
resource "aws_elasticache_replication_group" "redis_replication_group" {
  replication_group_id        = "${var.project_name}-${var.region_role}-redis"
  description                 = "Redis for session/cache"
  engine                      = var.redis_engine
  engine_version              = var.redis_engine_version
  node_type                   = var.redis_node_type
  num_cache_clusters          = var.redis_num_cache_clusters
  preferred_cache_cluster_azs = var.availability_zones
  port                        = var.redis_port
  subnet_group_name           = aws_elasticache_subnet_group.redis_subnet_group.name
  parameter_group_name        = aws_elasticache_parameter_group.redis_parameter_group.name
  security_group_ids          = [aws_security_group.redis_sg.id]
  at_rest_encryption_enabled  = true
  kms_key_id                  = var.kms_key_arn
  transit_encryption_enabled  = true
  snapshot_retention_limit    = var.snapshot_retention_limit
  snapshot_window             = var.snapshot_window
  maintenance_window          = var.maintenance_window
  automatic_failover_enabled  = true

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.region_role}-redis"
  })
}
