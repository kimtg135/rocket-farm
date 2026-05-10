# Aurora Global Database (Conditional creation)
resource "aws_rds_global_cluster" "db_global_cluster" {
  count                     = var.create_global_cluster ? 1 : 0
  global_cluster_identifier = "${var.project_name}-global-db"
  engine                    = var.db_engine
  engine_version            = var.db_engine_version
  database_name             = var.db_name
  storage_encrypted         = true
}

# DB Subnet Group
resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "${var.project_name}-db-subnet-group-${var.region_role}"
  subnet_ids  = var.db_subnet_ids
  description = "DB subnet group for ${var.region_role}"

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.region_role}-db-subnet-group"
  })
}

# DB Cluster Parameter Group
resource "aws_rds_cluster_parameter_group" "db_cluster_parameter_group" {
  name        = "${var.project_name}-db-cluster-pg-${var.region_role}"
  family      = var.db_family
  description = "Cluster parameter group for ${var.project_name}"

  parameter {
    name         = "character_set_server"
    value        = var.db_charset
    apply_method = "pending-reboot"
  }
  parameter {
    name         = "character_set_client"
    value        = var.db_charset
    apply_method = "pending-reboot"
  }
  parameter {
    name         = "character_set_connection"
    value        = var.db_charset
    apply_method = "pending-reboot"
  }
  parameter {
    name         = "character_set_database"
    value        = var.db_charset
    apply_method = "pending-reboot"
  }
  parameter {
    name         = "character_set_results"
    value        = var.db_charset
    apply_method = "pending-reboot"
  }
  parameter {
    name         = "collation_server"
    value        = var.db_collation
    apply_method = "pending-reboot"
  }
  parameter {
    name         = "collation_connection"
    value        = var.db_collation
    apply_method = "pending-reboot"
  }
  tags = var.common_tags
}

# DB Parameter Group (Instance level)
resource "aws_db_parameter_group" "db_instance_parameter_group" {
  name        = "${var.project_name}-db-pg-${var.region_role}"
  family      = var.db_family
  description = "DB parameter group for ${var.project_name}"

  tags = var.common_tags
}

# Aurora DB Cluster
resource "aws_rds_cluster" "db_cluster" {
  cluster_identifier        = "${var.project_name}-db-${var.region_role}"
  engine                    = var.db_engine
  engine_version            = var.db_engine_version
  global_cluster_identifier = var.create_global_cluster ? aws_rds_global_cluster.db_global_cluster[0].id : var.global_cluster_id

  master_username = var.create_global_cluster ? local.db_creds.DB_USERNAME : null
  master_password = var.create_global_cluster ? local.db_creds.DB_PASSWORD : null
  port            = var.db_port

  db_subnet_group_name            = aws_db_subnet_group.db_subnet_group.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.db_cluster_parameter_group.name
  vpc_security_group_ids          = [aws_security_group.db.id]
  storage_encrypted               = true
  kms_key_id                      = var.kms_key_arn

  skip_final_snapshot          = false
  final_snapshot_identifier    = "${var.project_name}-${var.region_role}-final-snapshot"
  deletion_protection          = true
  backup_retention_period      = var.backup_retention_period
  preferred_backup_window      = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window
  copy_tags_to_snapshot        = true

  lifecycle {
    ignore_changes = [
      replication_source_identifier,
      global_cluster_identifier
    ]
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.region_role}-db-cluster"
  })
}

# Aurora DB Cluster Instances
resource "aws_rds_cluster_instance" "db_instance" {
  count                   = var.db_num_instances
  identifier              = "${var.project_name}-db-${var.region_role}-instance-${count.index + 1}"
  cluster_identifier      = aws_rds_cluster.db_cluster.id
  instance_class          = var.db_instance_type
  engine                  = aws_rds_cluster.db_cluster.engine
  engine_version          = aws_rds_cluster.db_cluster.engine_version
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  db_parameter_group_name = aws_db_parameter_group.db_instance_parameter_group.name

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.region_role}-db-instance"
  })
}
