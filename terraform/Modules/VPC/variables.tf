variable "project_name" {
  description = "Project name"
  type        = string
}

variable "region_role" {
  description = "Region role"
  type        = string
  validation {
    condition     = contains(["main", "dr"], var.region_role)
    error_message = "region_role must be 'main' or 'dr'."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  validation {
    condition     = length(var.public_subnet_cidrs) == length(var.availability_zones)
    error_message = "The number of public_subnet_cidrs must match the number of availability_zones."
  }
}

variable "private_eks_subnet_cidrs" {
  description = "List of private EKS subnet CIDR blocks"
  type        = list(string)
  validation {
    condition     = length(var.private_eks_subnet_cidrs) == length(var.availability_zones)
    error_message = "The number of private_eks_subnet_cidrs must match the number of availability_zones."
  }
}

variable "private_db_subnet_cidrs" {
  description = "List of private database subnet CIDR blocks"
  type        = list(string)
  validation {
    condition     = length(var.private_db_subnet_cidrs) == length(var.availability_zones)
    error_message = "The number of private_db_subnet_cidrs must match the number of availability_zones."
  }
}

variable "eks_cluster_name" {
  description = "EKS cluster name for subnet tags"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}

variable "karpenter_tag" {
  description = "Tag value for Karpenter resource discovery"
  type        = string
}