#Defined Provider
provider "aws" {
  region = "us-east-1"
}

# Local variables
locals {
  default_tags = merge(
    var.default_tags,
    { "Env" = var.env}
  )
  name_prefix = "${var.env}-${var.prefix}"
}

#Defined Internet Gateway 
resource "aws_internet_gateway" "igw" {
  vpc_id = module.vpc-nonprod.vpc_id

 tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-igw"
    }
  )
}

#Defined Route Table for Public Subnet SN1
resource "aws_route_table" "public_rt" {
  vpc_id = module.vpc-nonprod.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  route{
     cidr_block = "10.100.0.0/16"
     gateway_id = aws_vpc_peering_connection.nonprod_prod_peering.id
 }
 tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-public-RT"
    }
  )
}

#Defined Association between Public_Subnet1 Subnet
resource "aws_route_table_association" "public" {
  count          = length(var.public_sn_cidrs)
  subnet_id      = module.vpc-nonprod.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public_rt.id
}

#Defined Elastic IP for NAT Gateway for Public Subnet
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
   tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-public-EIP"
    }
  )
}

#Defined NAT Gateway for Nonprod VPC Public_SN1
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = module.vpc-nonprod.public_subnet_ids[0]
   tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-public-NATGW"
    }
  )
}

#Defined Route Table for Private Subnet SN1 for Non Prod
resource "aws_route_table" "private_rt" {
  vpc_id = module.vpc-nonprod.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-private-RT"
    }
  )
}

#Defined Association between Private_SN1 Subnet Non Prod
resource "aws_route_table_association" "private" {
  count          = length(var.public_sn_cidrs)
  subnet_id      = module.vpc-nonprod.private_subnet_ids1[count.index]
  route_table_id = aws_route_table.private_rt.id
}

#Defined Route Table for Private Subnet SN2 for Prod
resource "aws_route_table" "private_rt1" {
  vpc_id = module.vpc-prod.vpc_id1
    route{
     cidr_block = "10.1.0.0/16"
     gateway_id = aws_vpc_peering_connection.nonprod_prod_peering.id
 }
  tags ={
      Name = "${var.env1}-${var.prefix}-private-RT"
    }
}

#Defined Association between Private_SN1 Subnet Prod
resource "aws_route_table_association" "private1" {
  count          = length(var.public_sn_cidrs)
  subnet_id      = module.vpc-prod.private_subnet_ids1[count.index]
  route_table_id = aws_route_table.private_rt1.id
}

#Defined VPC Peering Between NonProd and Prod
resource "aws_vpc_peering_connection" "nonprod_prod_peering" {
  peer_owner_id = 506712067076
  peer_vpc_id   = module.vpc-prod.vpc_id1
  vpc_id        = module.vpc-nonprod.vpc_id
  auto_accept   = true
  tags = {
    Name = "VPC Peering between NonProd and Prod"
  }
}
