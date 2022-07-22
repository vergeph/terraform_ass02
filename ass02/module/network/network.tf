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

# Create a new VPC 
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-vpc"
    }
  )
}

#Defined Public Subnet in Availability Zone us-east-1b
resource "aws_subnet" "public_sn1" {
  count                   = var.env == "nonprod" ? length(var.public_sn_cidrs) : 0
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_sn_cidrs[count.index]
  map_public_ip_on_launch = "true"
  availability_zone       = var.az[count.index]
  tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-public-subnet-${count.index}"
    }
  )
}

#Defined Private Subnet in Non Prod Environment
resource "aws_subnet" "private_sn1" {
  count                   = length(var.private_sn_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_sn_cidrs[count.index]
  map_public_ip_on_launch = "false"
  availability_zone       = var.az[count.index]
 tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-private-subnet-${count.index}"
    }
  )
}

