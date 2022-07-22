output "private_subnet_ids" {
  value = module.vpc-nonprod.private_subnet_ids
}

output "private_subnet_ids1" {
  value = module.vpc-prod.private_subnet_ids1
}

output "public_subnet_id1" {
  value = module.vpc-nonprod.public_subnet_ids
}

output "vpc_id" {
  value = module.vpc-nonprod.vpc_id
}

output "vpc_id1" {
  value = module.vpc-prod.vpc_id1
}

