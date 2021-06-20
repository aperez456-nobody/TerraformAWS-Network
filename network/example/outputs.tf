output "main_vpc_id" {
  value       = module.example_vpc.main_vpc_id
  description = "The main VPC id"
}

output "public_subnet_ids" {
  value       = module.example_vpc.public_subnet_ids
  description = "The public subnet ids"
}

output "private_subnet_ids" {
  value       = module.example_vpc.private_subnet_ids
  description = "The private subnet ids"
}
