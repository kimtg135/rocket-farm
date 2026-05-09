variable "project_name" {
  description = "Project name"
  type        = string
}

variable "regions" {
  description = "Region configuration"
  type = object({
    main = string
    dr   = string
  })
}

variable "common_tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}

variable "ecr_repositories" {
  description = "List of ECR repository names to create"
  type        = list(string)
}

variable "admin_iam_principal" {
  description = "IAM principal ARN allowed to manage KMS keys (e.g. arn:aws:iam::ACCOUNT_ID:role/DevOps)"
  type        = string
}
