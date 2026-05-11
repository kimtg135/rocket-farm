# 공통
aws_region          = "ap-northeast-2"
project_name        = "rocket-farm"
admin_iam_principal = "arn:aws:iam::ACCOUNT_ID:role/DevOps"

common_tags = {
  Project     = "rocket-farm"
  region_role = "main"
  Region      = "seoul"
}
region_role = "main"

# VPC
vpc_cidr = "10.155.0.0/16"
availability_zones = [
  "ap-northeast-2a",
  "ap-northeast-2c"
]
public_subnet_cidrs = [
  "10.155.11.0/24",
  "10.155.12.0/24"
]
private_eks_subnet_cidrs = [
  "10.155.32.0/20",
  "10.155.48.0/20"
]
private_db_subnet_cidrs = [
  "10.155.81.0/24",
  "10.155.82.0/24"
]

# EKS
cluster_name           = "rocket-farm-main"
kubernetes_version     = "1.35"
karpenter_tag          = "karpenter"
node_instance_type     = "c5.large"
node_app_instance_type = "c5.xlarge"
capacity_type          = "ON_DEMAND"

scaling_config_management = {
  desired_size = 2,
  min_size     = 2,
  max_size     = 3
}
scaling_config_app = {
  desired_size = 2,
  min_size     = 2,
  max_size     = 4
}
scaling_config_monitoring = {
  desired_size = 2,
  min_size     = 2,
  max_size     = 3
}

ebs_config_management = {
  volume_size           = 50,
  volume_type           = "gp3",
  encrypted             = true
  delete_on_termination = true
}
ebs_config_app = {
  volume_size           = 50,
  volume_type           = "gp3",
  encrypted             = true,
  delete_on_termination = true
}
ebs_config_monitoring = {
  volume_size           = 100,
  volume_type           = "gp3",
  encrypted             = true,
  delete_on_termination = true
}

node_taint = {
  key    = "dedicated",
  effect = "NO_SCHEDULE"
}

# Aurora
db_engine               = "aurora-mysql"
db_engine_version       = "8.0.mysql_aurora.3.05.2"
db_family               = "aurora-mysql8.0"
db_charset              = "utf8mb4"
db_collation            = "utf8mb4_unicode_ci"
db_name                 = "rocketfarm"
db_instance_type        = "db.r6g.xlarge"
db_num_instances        = 2
db_secret_name          = "rocket-farm/aurora/credentials"
db_port                 = 3306
backup_retention_period = 7
preferred_backup_window = "18:00-19:00"
db_maintenance_window   = "sun:19:00-sun:20:00"

# ElastiCache
redis_engine                 = "redis"
redis_engine_version         = "7.1"
redis_node_type              = "cache.r6g.xlarge"
redis_num_cache_clusters     = 2
redis_port                   = 6379
redis_parameter_group_family = "redis7"
redis_maxmemory_policy       = "allkeys-lru"
snapshot_retention_limit     = 7
snapshot_window              = "18:00-19:00"
redis_maintenance_window     = "sun:19:00-sun:20:00"