# 공통
variable "aws_region" {
  description = "AWS region"
  type        = string
}
variable "project_name" {
  description = "Project name"
  type        = string
}
variable "admin_iam_principal" {
  description = "Admin IAM principal"
  type        = string
}
variable "common_tags" {
  description = "Common tags"
  type        = map(string)
}
variable "region_role" {
  description = "Region role"
  type        = string
}

# VPC
variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}
variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
}
variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
}
variable "private_eks_subnet_cidrs" {
  description = "Private EKS subnet CIDR blocks"
  type        = list(string)
}
variable "private_db_subnet_cidrs" {
  description = "Private DB subnet CIDR blocks"
  type        = list(string)
}

# EKS (VPC 태그에도 사용)
variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}
variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
}
variable "karpenter_tag" {
  description = "Karpenter tag"
  type        = string
}
variable "node_instance_type" {
  description = "Node instance type"
  type        = string
}
variable "node_app_instance_type" {
  description = "App node instance type"
  type        = string
}
variable "capacity_type" {
  description = "Capacity type"
  type        = string
}
variable "scaling_config_management" {
  description = "Management scaling configuration"
  type = object({
    desired_size = number
    min_size     = number
    max_size     = number
  })
}
variable "scaling_config_app" {
  description = "App scaling configuration"
  type = object({
    desired_size = number
    min_size     = number
    max_size     = number
  })
}
variable "scaling_config_monitoring" {
  description = "Monitoring scaling configuration"
  type = object({
    desired_size = number
    min_size     = number
    max_size     = number
  })
}
variable "ebs_config_management" {
  description = "Management EBS configuration"
  type = object({
    volume_size           = number
    volume_type           = string
    encrypted             = bool
    delete_on_termination = bool
  })
}
variable "ebs_config_app" {
  description = "App EBS configuration"
  type = object({
    volume_size           = number
    volume_type           = string
    encrypted             = bool
    delete_on_termination = bool
  })
}
variable "ebs_config_monitoring" {
  description = "Monitoring EBS configuration"
  type = object({
    volume_size           = number
    volume_type           = string
    encrypted             = bool
    delete_on_termination = bool
  })
}
variable "node_taint" {
  description = "Node taint"
  type = object({
    key    = string
    effect = string
  })
}

# Aurora
variable "db_engine" {
  description = "Database engine"
  type        = string
}
variable "db_engine_version" {
  description = "Database engine version"
  type        = string
}
variable "db_family" {
  description = "Database family"
  type        = string
}
variable "db_charset" {
  description = "Database charset"
  type        = string
}
variable "db_collation" {
  description = "Database collation"
  type        = string
}
variable "db_name" {
  description = "Database name"
  type        = string
}
variable "db_instance_type" {
  description = "Database instance type"
  type        = string
}
variable "db_num_instances" {
  description = "Number of database instances"
  type        = number
}
variable "db_secret_name" {
  description = "Database secret name"
  type        = string
}
variable "db_port" {
  description = "Database port"
  type        = number
}
variable "backup_retention_period" {
  description = "Backup retention period"
  type        = number
}
variable "preferred_backup_window" {
  description = "Preferred backup window (KST = 03:00-04:00)"
  type        = string
}
variable "db_maintenance_window" {
  description = "Database maintenance window (KST = 03:00-04:00)"
  type        = string
}

variable "global_cluster_id" {
  description = "Global cluster ID for Aurora Global Database (leave empty if not using)"
  type        = string
}

# ElastiCache
variable "redis_engine" {
  description = "Redis engine"
  type        = string
}
variable "redis_engine_version" {
  description = "Redis engine version"
  type        = string
}
variable "redis_node_type" {
  description = "Redis node type"
  type        = string
}
variable "redis_num_cache_clusters" {
  description = "Number of Redis cache clusters"
  type        = number
}
variable "redis_port" {
  description = "Redis port"
  type        = number
}
variable "redis_parameter_group_family" {
  description = "Redis parameter group family"
  type        = string
}
variable "redis_maxmemory_policy" {
  description = "Redis maxmemory policy"
  type        = string
}
variable "snapshot_retention_limit" {
  description = "Snapshot retention limit"
  type        = number
}
variable "snapshot_window" {
  description = "Snapshot window (KST = 03:00-04:00)"
  type        = string
}
variable "redis_maintenance_window" {
  description = "Redis maintenance window (KST = 03:00-04:00)"
  type        = string
}