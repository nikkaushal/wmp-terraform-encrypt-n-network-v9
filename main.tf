# module "databases" {
#   for_each = var.databases
#   source   = "./modules/rds"

#   env               = var.env
#   subnet_ids        = var.subnets
#   kms_key_id        = var.kms_key_id
  
#   allocated_storage = each.value["allocated_storage"]

# }

# module "eks" {
  
#   source = "./modules/eks"

#   env        = var.env
#   subnet_ids  = var.subnets
#   kms_key_id  = var.kms_key_id
# }

module "network" {
  for_each       = var.network
  source         = "./modules/network"

  env            = var.env
  vpc_cidr       = each.value["vpc_cidr"]
  subnets = each.value["subnets"]
  default_vpc_id = var.vpc_id
} 

# module "apps" {
#   depends_on = [module.databases]

#   source        = "./modules/component-with-alb"
#   dns_domain    = var.dns_domain
#   env           = var.env
#   subnets       = var.subnets
#   vpc_id        = var.vpc_id
#   for_each      = var.apps
#   instance_type = each.value["instance_type"]
#   component     = each.key
#   ports         = each.value["ports"]
#   lb            = each.value["lb"]
#   asg           = each.value["asg"]
#   postgres_rds_address = module.databases[ "postgres" ].postgres_rds_address

# }

