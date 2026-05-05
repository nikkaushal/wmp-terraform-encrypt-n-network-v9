output "subnet_ids" {
  value = [for i, j in aws_subnet.main : j.id]
}

output "vpc_id" {
  value = aws_vpc.main
}