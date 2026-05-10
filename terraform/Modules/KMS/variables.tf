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

variable "admin_iam_principal" {
  description = "Admin IAM principal ARN"
  type        = string
}

variable "eks_cluster_name" {
  description = "EKS cluster name for IAM policy"
  type        = string
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}