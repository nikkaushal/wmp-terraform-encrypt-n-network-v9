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
output "public_subnet_ids" {
  value = {
    for k, v in local.public_subnets :
    k => aws_subnet.main[k].id
  }
}

output "app_subnet_ids" {
  value = {
    for k, v in local.app_subnets :
    k => aws_subnet.main[k].id
  }
}

output "db_subnet_ids" {
  value = {
    for k, v in local.db_subnets :
    k => aws_subnet.main[k].id
  }
}