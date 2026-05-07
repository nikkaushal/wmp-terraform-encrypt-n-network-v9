output "subnet_ids" {
  value = module.network
}
output "public_subnet_ids" {
  value = module.network[var.env].public_subnet_ids
}
output "app_subnet_ids" {
  value = module.network[var.env].app_subnet_ids
}
output "db_subnet_ids" {  
  value = module.network[var.env].db_subnet_ids
}