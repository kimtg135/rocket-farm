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

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for EKS cluster and node groups"
  type        = list(string)
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+$", var.kubernetes_version))
    error_message = "kubernetes_version must be in 'major.minor' format (e.g., 1.31)."
  }
}

variable "cluster_log_types" {
  description = "List of enabled cluster log types"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "kms_key_arn" {
  description = "KMS Key ARN for EKS encryption"
  type        = string
}

variable "karpenter_tag" {
  description = "Tag value for Karpenter resource discovery"
  type        = string
  default     = "karpenter"
}

# Add-ons
variable "addon_coredns_version" {
  description = "CoreDNS addon version"
  type        = string
  default     = null
}

variable "addon_kube_proxy_version" {
  description = "Kube-proxy addon version"
  type        = string
  default     = null
}

variable "addon_vpc_cni_version" {
  description = "VPC-CNI addon version"
  type        = string
  default     = null
}

variable "addon_resolve_conflicts" {
  description = "How to resolve conflicts for addons"
  type        = string
  default     = "OVERWRITE"
}

# Node Groups
variable "node_instance_type" {
  description = "Instance type for managed node groups"
  type        = string
}


variable "node_app_instance_type" {
  description = "Instance type for app node groups"
  type        = string
}

variable "capacity_type" {
  description = "Capacity type for managed node groups (ON_DEMAND or SPOT)"
  type        = string
  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.capacity_type)
    error_message = "capacity_type must be either 'ON_DEMAND' or 'SPOT'."
  }
}

variable "scaling_config_management" {
  description = "Scaling config for management node group"
  type = object({
    desired_size = number
    min_size     = number
    max_size     = number
  })
}

variable "scaling_config_app" {
  description = "Scaling config for app node group"
  type = object({
    desired_size = number
    min_size     = number
    max_size     = number
  })
}

variable "scaling_config_monitoring" {
  description = "Scaling config for monitoring node group"
  type = object({
    desired_size = number
    min_size     = number
    max_size     = number
  })
}

variable "ebs_config_management" {
  description = "EBS config for management node group"
  type = object({
    volume_size           = number
    volume_type           = string
    encrypted             = bool
    delete_on_termination = bool
  })
}

variable "ebs_config_app" {
  description = "EBS config for app node group"
  type = object({
    volume_size           = number
    volume_type           = string
    encrypted             = bool
    delete_on_termination = bool
  })
}

variable "ebs_config_monitoring" {
  description = "EBS config for monitoring node group"
  type = object({
    volume_size           = number
    volume_type           = string
    encrypted             = bool
    delete_on_termination = bool
  })
}

variable "pod_label_management" {
  type    = string
  default = "management"
}
variable "pod_label_app" {
  type    = string
  default = "app"
}
variable "pod_label_monitoring" {
  type    = string
  default = "monitoring"
}

variable "node_taint" {
  description = "Taint config for node groups"
  type = object({
    key    = string
    effect = string
  })
}

# IAM
variable "node_access_entry_type" {
  description = "Access entry type for nodes"
  type        = string
  default     = "EC2_LINUX"
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "extra_ingress_cidrs" {
  description = "Extra CIDR blocks to allow in node security group"
  type        = list(string)
  default     = []
}
