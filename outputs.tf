output "subnet_ids" {
  value = module.network
}
output "public_subnet_ids" {
  value = module.network[var.env].public_subnet_ids
}