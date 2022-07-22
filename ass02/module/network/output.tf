# Add output variables
output "private_subnet_ids" {
value = aws_subnet.private_sn1[*].id
}

output "private_subnet_ids1" {
value = aws_subnet.private_sn1[*].id
}

output "public_subnet_ids" {
value = aws_subnet.public_sn1[*].id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_id1" {
  value = aws_vpc.main.id
}