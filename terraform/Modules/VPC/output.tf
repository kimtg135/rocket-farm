output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_eks_subnet_ids" {
  value = aws_subnet.private_eks[*].id
}

output "private_db_subnet_ids" {
  value = aws_subnet.private_db[*].id
}

output "private_eks_subnet_cidrs" {
  value = aws_subnet.private_eks[*].cidr_block
}

output "nat_gateway_ids" {
  value = aws_nat_gateway.main[*].id
}