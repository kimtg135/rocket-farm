variable "project_name" {
  description = "Project name"
  type        = string
}

variable "region_role" {
  description = "Region role (e.g., main, dr)"
  type        = string
  validation {
    condition     = contains(["main", "dr"], var.region_role)
    error_message = "region_role must be either 'main' or 'dr'."
  }
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the Redis subnet group"
  type        = list(string)
}

variable "app_subnet_cidrs" {
  description = "CIDR blocks allowed to access Redis"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "redis_engine" {
  description = "Redis engine (e.g., redis, valkey)"
  type        = string
  validation {
    condition     = contains(["redis", "valkey"], var.redis_engine)
    error_message = "redis_engine must be either 'redis' or 'valkey'."
  }
}

variable "redis_engine_version" {
  description = "Redis engine version"
  type        = string
}

variable "redis_node_type" {
  description = "Redis instance type"
  type        = string
}

variable "redis_num_cache_clusters" {
  description = "Number of cache clusters"
  type        = number
  validation {
    condition     = var.redis_num_cache_clusters >= 1
    error_message = "redis_num_cache_clusters must be at least 1."
  }
}

variable "redis_port" {
  description = "Redis port"
  type        = number
  validation {
    condition     = var.redis_port > 0 && var.redis_port < 65536
    error_message = "redis_port must be a valid port number (1-65535)."
  }
}

variable "kms_key_arn" {
  description = "KMS Key ARN for encryption at rest"
  type        = string
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "redis_parameter_group_family" {
  description = "ElastiCache parameter group family"
  type        = string
}

variable "redis_maxmemory_policy" {
  description = "Redis maxmemory eviction policy"
  type        = string
}

variable "snapshot_retention_limit" {
  description = "Number of days to retain Redis snapshots (0 = disabled)"
  type        = number
}

variable "snapshot_window" {
  description = "Daily time range for snapshots (UTC, KST = 03:00-04:00)"
  type        = string
}

variable "maintenance_window" {
  description = "Weekly time range for maintenance (UTC, KST = mon:04:00-mon:05:00)"
  type        = string
}