output "subnet_ids" {
  value = [for i, j in aws_subnet.main : j.id]
}

output "vpc_id" {
  value = aws_vpc.main
}

# Temporarily add to modules/network/outputs.tf
output "debug_igw_subnets" {
  value = local.igw_subnets
}

output "debug_ngw_subnets" {
  value = local.ngw_subnets
}