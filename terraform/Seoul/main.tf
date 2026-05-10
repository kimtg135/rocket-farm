module "vpc" {
  source = "../Modules/VPC"

  project_name             = var.project_name
  region_role              = var.region_role
  vpc_cidr                 = var.vpc_cidr
  availability_zones       = var.availability_zones
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_eks_subnet_cidrs = var.private_eks_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs
  eks_cluster_name         = var.cluster_name
  karpenter_tag            = var.karpenter_tag
  common_tags              = var.common_tags
}

module "kms" {
  source = "../Modules/KMS"

  project_name        = var.project_name
  region_role         = var.region_role
  admin_iam_principal = var.admin_iam_principal
  eks_cluster_name    = var.cluster_name
  common_tags         = var.common_tags
}

module "eks" {
  source = "../Modules/EKS"

  project_name        = var.project_name
  region_role         = var.region_role
  vpc_id              = module.vpc.vpc_id
  vpc_cidr            = module.vpc.vpc_cidr
  subnet_ids          = module.vpc.private_eks_subnet_ids
  cluster_name        = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  kms_key_arn         = module.kms.eks_kms_key_arn
  admin_iam_principal = var.admin_iam_principal
  karpenter_tag       = var.karpenter_tag
  common_tags         = var.common_tags

  node_instance_type     = var.node_instance_type
  node_app_instance_type = var.node_app_instance_type
  capacity_type          = var.capacity_type

  scaling_config_management = var.scaling_config_management
  scaling_config_app        = var.scaling_config_app
  scaling_config_monitoring = var.scaling_config_monitoring

  ebs_config_management = var.ebs_config_management
  ebs_config_app        = var.ebs_config_app
  ebs_config_monitoring = var.ebs_config_monitoring

  node_taint = var.node_taint
}

module "aurora" {
  source = "../Modules/DB/Aurora"

  project_name     = var.project_name
  region_role      = var.region_role
  vpc_id           = module.vpc.vpc_id
  db_subnet_ids    = module.vpc.private_db_subnet_ids
  app_subnet_cidrs = module.vpc.private_eks_subnet_cidrs
  kms_key_arn      = module.kms.aurora_kms_key_arn
  common_tags      = var.common_tags

  db_engine         = var.db_engine
  db_engine_version = var.db_engine_version
  db_family         = var.db_family
  db_charset        = var.db_charset
  db_collation      = var.db_collation
  db_name           = var.db_name
  db_instance_type  = var.db_instance_type
  db_num_instances  = var.db_num_instances
  db_secret_name    = var.db_secret_name
  db_port           = var.db_port

  create_global_cluster        = true
  backup_retention_period      = var.backup_retention_period
  preferred_backup_window      = var.preferred_backup_window
  preferred_maintenance_window = var.db_maintenance_window
}

module "redis" {
  source = "../Modules/DB/ElastiCache"

  project_name       = var.project_name
  region_role        = var.region_role
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_eks_subnet_ids
  app_subnet_cidrs   = module.vpc.private_eks_subnet_cidrs
  availability_zones = var.availability_zones
  kms_key_arn        = module.kms.redis_kms_key_arn
  common_tags        = var.common_tags

  redis_engine                 = var.redis_engine
  redis_engine_version         = var.redis_engine_version
  redis_node_type              = var.redis_node_type
  redis_num_cache_clusters     = var.redis_num_cache_clusters
  redis_port                   = var.redis_port
  redis_parameter_group_family = var.redis_parameter_group_family
  redis_maxmemory_policy       = var.redis_maxmemory_policy
  snapshot_retention_limit     = var.snapshot_retention_limit
  snapshot_window              = var.snapshot_window
  maintenance_window           = var.redis_maintenance_window
}