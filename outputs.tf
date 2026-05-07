output "subnet_ids" {
  value = module.network
}
output "db_subnet_ids" {
  value = module.network.db_subnet_ids
}