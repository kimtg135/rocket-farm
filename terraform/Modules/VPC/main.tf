locals {
  az_suffixes = [
    for az in var.availability_zones : replace(az, "/^.*-([0-9][a-z])$/", "$1")
  ]
}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.region_role}-vpc"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.region_role}-igw"
  })
}

# Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name                                            = "${var.project_name}-${var.region_role}-public-${local.az_suffixes[count.index]}"
    Tier                                            = "public"
    "kubernetes.io/role/elb"                        = "1"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    AZ                                              = local.az_suffixes[count.index]
  })
}

# Private EKS Subnets
resource "aws_subnet" "private_eks" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_eks_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(var.common_tags, {
    Name                                            = "${var.project_name}-${var.region_role}-private-eks-${local.az_suffixes[count.index]}"
    Tier                                            = "private-eks"
    "kubernetes.io/role/internal-elb"               = "1"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "karpenter/eks-cluster"                         = var.eks_cluster_name
    "karpenter/karpenter-tag"                       = var.karpenter_tag
    AZ                                              = local.az_suffixes[count.index]
  })
}

# Private DB Subnets
resource "aws_subnet" "private_db" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_db_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.region_role}-private-db-${local.az_suffixes[count.index]}"
    Tier = "private-db"
    AZ   = local.az_suffixes[count.index]
  })
}

# EIP + NAT Gateway (AZ별 1개)
resource "aws_eip" "nat" {
  count  = length(var.availability_zones)
  domain = "vpc"

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.region_role}-nat-eip-${local.az_suffixes[count.index]}"
  })
}

resource "aws_nat_gateway" "main" {
  count         = length(var.availability_zones)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.region_role}-nat-${local.az_suffixes[count.index]}"
  })

  depends_on = [aws_internet_gateway.igw]
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.region_role}-public-rt"
  })
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private EKS Route Table (AZ별 1개)
resource "aws_route_table" "private_eks" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.vpc.id

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.region_role}-private-eks-rt-${local.az_suffixes[count.index]}"
  })
}

resource "aws_route_table_association" "private_eks" {
  count          = length(aws_subnet.private_eks)
  subnet_id      = aws_subnet.private_eks[count.index].id
  route_table_id = aws_route_table.private_eks[count.index].id
}

resource "aws_route" "private_eks_default" {
  count                  = length(var.availability_zones)
  route_table_id         = aws_route_table.private_eks[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[count.index].id
}

# Private DB Route Table (외부 라우트 없음)
resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.region_role}-private-db-rt"
  })
}

resource "aws_route_table_association" "private_db" {
  count          = length(aws_subnet.private_db)
  subnet_id      = aws_subnet.private_db[count.index].id
  route_table_id = aws_route_table.private_db.id
}