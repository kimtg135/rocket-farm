resource "aws_security_group" "eks_cluster" {
  name        = "${var.cluster_name}-cluster-sg"
  description = "EKS cluster security group"
  vpc_id      = var.vpc_id

  # Ingress rules (Migrated from original eks-sg)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = concat([var.vpc_cidr], var.extra_ingress_cidrs)
    description = "Allow VPC and extra CIDRs to communicate with cluster API server"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name                      = "${var.cluster_name}-cluster-sg"
    "karpenter/eks-cluster"   = var.cluster_name
    "karpenter/karpenter-tag" = var.karpenter_tag
  })
}

resource "aws_security_group" "nodes" {
  name        = "${var.cluster_name}-node-sg"
  description = "Security group for all nodes in the cluster"
  vpc_id      = var.vpc_id

  # Ingress rules (Migrated from original auto-scaling-sg & node-link-sg)
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    description = "Allow all node-to-node communication"
  }

  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "VPC ingress kubelet"
  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "Karpenter webhook"
  }

  ingress {
    description = "Allow application ports from ALB and VPC"
    from_port   = 8080
    to_port     = 8085
    protocol    = "tcp"
    cidr_blocks = concat([var.vpc_cidr], var.extra_ingress_cidrs)
  }

  ingress {
    description = "Allow frontend port"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = concat([var.vpc_cidr], var.extra_ingress_cidrs)
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "VPC ingress DNS"
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = [var.vpc_cidr]
    description = "VPC ingress DNS"
  }

  ingress {
    from_port   = 9443
    to_port     = 9443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "Allow Karpenter controller to communicate with nodes (if using webhook)"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name                      = "${var.cluster_name}-node-sg"
    "karpenter/eks-cluster"   = var.cluster_name
    "karpenter/karpenter-tag" = var.karpenter_tag
  })
}

# EKS cluster 생성시 자동으로 생성되는 SG에 karpenter tag 추가
resource "aws_ec2_tag" "cluster_sg_karpenter" {
  resource_id = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
  key         = "karpenter/karpenter-tag"
  value       = var.karpenter_tag
}

resource "aws_ec2_tag" "cluster_sg_eks_cluster" {
  resource_id = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
  key         = "karpenter/eks-cluster"
  value       = var.cluster_name
}
