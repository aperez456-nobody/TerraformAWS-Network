output "region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = local.cluster_name
}

output "main_vpc_id" {
  value       = module.vpc["vpc_id"]
  description = "The main VPC id"
}

output "public_subnet_ids" {
  value       = module.vpc["public_subnets"]
  description = "The public subnet id"
}

output "private_subnet_ids" {
  value       = module.vpc["private_subnets"]
  description = "The private subnet id"
}
