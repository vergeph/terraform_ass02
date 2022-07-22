terraform {
  required_version = ">= 1.0.0, < 2.0.0"
  }

terraform {
  backend "s3" {
    bucket = "acs730-ass02-vpaguibitan"      // Bucket where to SAVE Terraform State
    key    = "network/terraform.tfstate"    // Object name in the bucket to SAVE Terraform State
    region = "us-east-1"                           // Region where bucket is created
  }
}

# Module to deploy networking for NonProd and Prod with VPC Peering
module "vpc-nonprod" {
  source = "../../../ass02/module/network"
  env                         = var.env
  vpc_cidr                    = var.vpc_cidr
  public_sn_cidrs             = var.public_sn_cidrs
  private_sn_cidrs            = var.private_sn_cidrs 
  az                          = var.az
  prefix                      = var.prefix
  default_tags                = var.default_tags
}

module "vpc-prod" {
  source = "../../../ass02/module/network"
  env                         = var.env1
  vpc_cidr                    = var.vpc_cidr1
  public_sn_cidrs             = [""]
  private_sn_cidrs            = var.private_sn_cidrs1 
  az                          = var.az
  prefix                      = var.prefix
  default_tags                = var.default_tags
}

