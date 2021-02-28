output "vpc_id" {
  value = aws_vpc.elasticsearch.id
}

output "vpc_cidr" {
  value = aws_vpc.elasticsearch.cidr_block
}

output "subnet_ids" {
  value = aws_subnet.elasticsearch[*].id
}