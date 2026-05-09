resource "aws_security_group" "db" {
  name        = "${var.project_name}-${var.region_role}-db-sg"
  description = "Security group for Aurora DB"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow MySQL from app subnets"
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = var.app_subnet_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.region_role}-db-sg"
  })
}
