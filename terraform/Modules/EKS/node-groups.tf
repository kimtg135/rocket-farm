# Launch Templates
resource "aws_launch_template" "launch_template" {
  for_each = {
    management = var.ebs_config_management
    app        = var.ebs_config_app
    monitoring = var.ebs_config_monitoring
  }

  name_prefix = "${var.cluster_name}-${each.key}-"

  network_interfaces {
    security_groups = [
      aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id,
      aws_security_group.nodes.id,
      aws_security_group.eks_cluster.id
    ]
    delete_on_termination = true
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = each.value.volume_size
      volume_type           = each.value.volume_type
      encrypted             = each.value.encrypted
      kms_key_id            = var.kms_key_arn
      delete_on_termination = each.value.delete_on_termination
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.common_tags, {
      Name = "${var.cluster_name}-${each.key}-node"
    })
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Node Groups
resource "aws_eks_node_group" "management" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.cluster_name}-management"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.subnet_ids

  capacity_type  = var.capacity_type
  instance_types = [var.node_instance_type]

  launch_template {
    id      = aws_launch_template.launch_template["management"].id
    version = aws_launch_template.launch_template["management"].latest_version
  }

  scaling_config {
    desired_size = var.scaling_config_management.desired_size
    min_size     = var.scaling_config_management.min_size
    max_size     = var.scaling_config_management.max_size
  }

  labels = { role = var.pod_label_management }

  taint {
    key    = var.node_taint.key
    value  = var.pod_label_management
    effect = var.node_taint.effect
  }

  tags = merge(var.common_tags, {
    Name = "${var.cluster_name}-management-ng"
  })

  lifecycle {
    ignore_changes = [launch_template[0].version]
  }
}

resource "aws_eks_node_group" "app" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.cluster_name}-app"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.subnet_ids

  capacity_type  = var.capacity_type
  instance_types = [var.node_app_instance_type]

  launch_template {
    id      = aws_launch_template.launch_template["app"].id
    version = aws_launch_template.launch_template["app"].latest_version
  }

  scaling_config {
    desired_size = var.scaling_config_app.desired_size
    min_size     = var.scaling_config_app.min_size
    max_size     = var.scaling_config_app.max_size
  }

  labels = { role = var.pod_label_app }

  tags = merge(var.common_tags, {
    Name = "${var.cluster_name}-app-ng"
  })

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size, launch_template[0].version]
  }
}

resource "aws_eks_node_group" "monitoring" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.cluster_name}-monitoring"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.subnet_ids

  capacity_type  = var.capacity_type
  instance_types = [var.node_instance_type]

  launch_template {
    id      = aws_launch_template.launch_template["monitoring"].id
    version = aws_launch_template.launch_template["monitoring"].latest_version
  }

  scaling_config {
    desired_size = var.scaling_config_monitoring.desired_size
    min_size     = var.scaling_config_monitoring.min_size
    max_size     = var.scaling_config_monitoring.max_size
  }

  labels = { role = var.pod_label_monitoring }

  taint {
    key    = var.node_taint.key
    value  = var.pod_label_monitoring
    effect = var.node_taint.effect
  }

  tags = merge(var.common_tags, {
    Name = "${var.cluster_name}-monitoring-ng"
  })

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size, launch_template[0].version]
  }
}
