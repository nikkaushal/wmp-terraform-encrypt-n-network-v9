locals {
  # Filter subnets where igw = true
  igw_subnets = {
    for subnet_name, subnet_config in var.subnets :
    subnet_name => subnet_config
    if subnet_config.igw == true
  }

  # Filter subnets where ngw = true
  ngw_subnets = {
    for subnet_name, subnet_config in var.subnets :
    subnet_name => subnet_config
    if subnet_config.ngw == true
  }
    public_subnets = {
    for subnet_name, subnet_config in var.subnets :
    subnet_name => subnet_config
    if subnet_config.group == "public"
  }

  app_subnets = {
    for subnet_name, subnet_config in var.subnets :
    subnet_name => subnet_config
    if subnet_config.group == "app"
  }

  db_subnets = {
    for subnet_name, subnet_config in var.subnets :
    subnet_name => subnet_config
    if subnet_config.group == "db"
  }
}



# modules/network/locals.tf

# locals {
#   igw_subnets = {
#     for subnet_name, subnet_config in var.subnets :
#     subnet_name => subnet_config
#     if subnet_config.igw == true
#   }

#   ngw_subnets = {
#     for subnet_name, subnet_config in var.subnets :
#     subnet_name => subnet_config
#     if subnet_config.ngw == true
#   }

#   # Map AZ -> NAT Gateway key (public subnet name)
#   # e.g. "us-east-1a" -> "public-subnet1"
#   az_to_ngw = {
#     for subnet_name, subnet_config in local.igw_subnets :
#     subnet_config.az => subnet_name
#   }
# }