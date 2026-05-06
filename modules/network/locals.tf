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
}