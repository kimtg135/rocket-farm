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
  description = "VPC ID where RDS will be deployed"
  type        = string
}

variable "db_subnet_ids" {
  description = "List of subnet IDs for DB subnet group"
  type        = list(string)
}

variable "db_engine" {
  description = "Database engine"
  type        = string
  validation {
    condition     = contains(["aurora-mysql", "aurora-postgresql"], var.db_engine)
    error_message = "Currently only 'aurora-mysql' and 'aurora-postgresql' are supported in this validation."
  }
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
}

variable "db_family" {
  description = "Database parameter group family"
  type        = string
}

variable "db_charset" {
  description = "Database character set"
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
  description = "RDS instance class"
  type        = string
}

variable "db_num_instances" {
  description = "Number of RDS instances"
  type        = number
  validation {
    condition     = var.db_num_instances >= 1
    error_message = "db_num_instances must be at least 1."
  }
}

variable "db_secret_name" {
  description = "Secret name in AWS Secrets Manager for DB credentials"
  type        = string
}

variable "kms_key_arn" {
  description = "KMS Key ARN for storage encryption"
  type        = string
}

variable "create_global_cluster" {
  description = "Whether to create a global cluster"
  type        = bool
}

variable "global_cluster_id" {
  description = "Global cluster ID (if create_global_cluster is false)"
  type        = string
  default     = null
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups (1-35)"
  type        = number
}

variable "preferred_backup_window" {
  description = "Daily time range for automated backups (KST = 03:00-04:00)"
  type        = string
}

variable "preferred_maintenance_window" {
  description = "Weekly time range for maintenance (KST = mon:04:00-mon:05:00)"
  type        = string
}

variable "app_subnet_cidrs" {
  description = "CIDR blocks allowed to access Aurora DB"
  type        = list(string)
}

variable "db_port" {
  description = "Database port"
  type        = number
  validation {
    condition     = var.db_port > 0 && var.db_port < 65536
    error_message = "db_port must be a valid port number (1-65535)."
  }
}