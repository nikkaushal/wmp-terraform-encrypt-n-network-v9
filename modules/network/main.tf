resource aws_vpc "main" {
  cidr_block = var.vpc_cidr
    tags = {
        Name = var.env
    }
}

resource "aws_subnet" "main" {
  for_each = var.subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]
  tags = {
    Name = each.key
  }
  
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = var.env
  }
}
resource "aws_route_table" "main" {
  for_each = var.subnets
  vpc_id = aws_vpc.main.id
  tags = {
    Name = var.env
  }
}
resource "aws_route_table_association" "main" {
  for_each = var.subnets
  subnet_id      = aws_subnet.main[each.key].id
  route_table_id = aws_route_table.main[each.key].id
}
# IGW routes - only for public subnets (igw = true)
resource "aws_route" "igw-route" {
  for_each               = local.igw_subnets
  route_table_id         = aws_route_table.main[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}
# NAT Gateway EIP - one per igw subnet AZ
resource "aws_eip" "ngw" {
  for_each = local.igw_subnets
  domain   = "vpc"
}
# NAT Gateway - one per ngw subnet
resource "aws_nat_gateway" "ngw" {
  for_each      = local.igw_subnets
  allocation_id = aws_eip.ngw[each.key].id
  subnet_id     = aws_subnet.main[each.key].id
}

# NGW routes - only for private subnets (ngw = true)
resource "aws_route" "ngw-route" {
  for_each               = local.ngw_subnets
  route_table_id         = aws_route_table.main[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  # Look up NAT GW by matching AZ of the app subnet to AZ of the public subnet
  nat_gateway_id         = aws_nat_gateway.ngw[local.az_to_ngw[each.value.az]].id
}
# resource "aws_vpc_peering_connection" "main" {
#   vpc_id        = var.default_vpc_id
#   peer_vpc_id   = aws_vpc.main.id
#   auto_accept = true 
#   tags = {
#     Name = "default-to-${var.env}"
#   }
  
# }

# resource "aws_route" "default-rt-add-peering" {
#   route_table_id         = var.default_vpc_rt_id
#   destination_cidr_block = var.vpc_cidr
#   vpc_peering_connection_id = aws_vpc_peering_connection.main.id
# }
# resource "aws_route" "here-vpc-rt-add-peering" {
#   route_table_id         = aws_vpc.main.default_route_table_id
#   destination_cidr_block = var.default_vpc_cidr
#   vpc_peering_connection_id = aws_vpc_peering_connection.main.id
# }