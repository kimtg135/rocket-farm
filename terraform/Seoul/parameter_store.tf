# Parameter Store
resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project_name}/${var.region_role}/vpc/vpc_id"
  type  = "String"
  value = module.vpc.vpc_id
}

resource "aws_ssm_parameter" "eks_main_endpoint" {
  name  = "/${var.project_name}/${var.region_role}/eks/endpoint"
  type  = "String"
  value = module.eks.cluster_endpoint
}

resource "aws_ssm_parameter" "kms_key_id" {
  name  = "/${var.project_name}/${var.region_role}/kms/key_id"
  type  = "String"
  value = module.kms.eks_kms_key_id
}

# rds_enpoint의 기존 값 -> 트러블 슈팅 , migration에 사용
resource "aws_ssm_parameter" "aurora_cluster_endpoint" {
  name  = "/${var.project_name}/${var.region_role}/aurora/aurora_cluster_endpoint"
  type  = "String"
  value = module.aurora.cluster_endpoint
}

resource "aws_ssm_parameter" "aurora_port" {
  name  = "/${var.project_name}/${var.region_role}/aurora/port"
  type  = "String"
  value = "3306"
}

resource "aws_ssm_parameter" "redis_endpoint" {
  name  = "/${var.project_name}/${var.region_role}/redis/endpoint"
  type  = "String"
  value = module.redis.primary_endpoint_address
}

resource "aws_ssm_parameter" "redis_port" {
  name  = "/${var.project_name}/${var.region_role}/redis/port"
  type  = "String"
  value = "6379"
}
