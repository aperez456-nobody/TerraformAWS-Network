data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  cluster_name  = "terraform-eks-${var.environment}-${random_string.suffix.result}"
  CreatedBy     = "Terraform"
  ManagedBy     = "Terraform"
  Private       = "Private"
  Public        = "Public"
  shared        = "shared"
  ELB           = "1"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

//resource "aws_vpc" "vpc" {
//  cidr_block = var.vpc_cidr_block
//
//  tags = {
//    CreatedBy                                   = local.CreatedBy
//    MangedBy                                    = local.ManagedBy
//    Environment                                 = var.environment
//  }
//}
//
//resource "aws_internet_gateway" "main_gateway" {
//  vpc_id = aws_vpc.vpc.id
//
//  tags = {
//    CreatedBy                                   = local.CreatedBy
//    MangedBy                                    = local.ManagedBy
//    Environment                                 = var.environment
//  }
//}
//
//resource "aws_subnet" "private" {
//  count                   = length(var.private_cidr_blocks)
//  vpc_id                  = aws_vpc.vpc.id
//  cidr_block              = var.private_cidr_blocks[count.index]
//  map_public_ip_on_launch = false
//
//  tags = {
//    CreatedBy                                   = local.CreatedBy
//    MangedBy                                    = local.ManagedBy
//    Environment                                 = var.environment
//    Tier                                        = local.Private
//  }
//
//  availability_zone = data.aws_availability_zones.available.names[count.index]
//}
//
//resource "aws_subnet" "public" {
//  count                   = length(var.public_cidr_blocks)
//  vpc_id                  = aws_vpc.vpc.id
//  cidr_block              = var.public_cidr_blocks[count.index]
//  map_public_ip_on_launch = true
//
//  tags = {
//    CreatedBy                                   = local.CreatedBy
//    MangedBy                                    = local.ManagedBy
//    Environment                                 = var.environment
//    Tier                                        = local.Public
//  }
//
//  availability_zone = data.aws_availability_zones.available.names[count.index]
//}
//
//# ---------------------------------------------------------------------------------------------------------------------
//# CREATE AND ATTACH A ROUTING TABLE FOR THE PUBLIC NETWORK
//# ---------------------------------------------------------------------------------------------------------------------
//
//resource "aws_route_table" "public" {
//  vpc_id = aws_vpc.vpc.id
//
//  route {
//    cidr_block = "91.189.0.0/24"
//    gateway_id = aws_internet_gateway.main_gateway.id
//  }
//
//  tags = {
//    CreatedBy                                   = local.CreatedBy
//    MangedBy                                    = local.ManagedBy
//    Environment                                 = var.environment
//    Tier                                        = local.Public
//  }
//}
//
//resource "aws_route_table_association" "public" {
//  count           = length(aws_subnet.public)
//  subnet_id       = aws_subnet.public[count.index].id
//  route_table_id  = aws_route_table.public.id
//}
//
//# ---------------------------------------------------------------------------------------------------------------------
//# CREATE NAT GATEWAY FOR THE PRIVATE SUBNET
//# ---------------------------------------------------------------------------------------------------------------------
//
//resource "aws_eip" "nat" {
//  vpc = true
//}
//
//resource "aws_nat_gateway" "nat" {
//  allocation_id = aws_eip.nat.id
//  subnet_id     = aws_subnet.public[0].id
//  depends_on    = [aws_internet_gateway.main_gateway]
//}
//
//# ---------------------------------------------------------------------------------------------------------------------
//# CREATE AND ATTACH A ROUTING TABLE FOR THE PRIVATE NETWORK
//# ---------------------------------------------------------------------------------------------------------------------
//
//resource "aws_route_table" "private" {
//  vpc_id = aws_vpc.vpc.id
//
//  route {
//    cidr_block     = "0.0.0.0/0"
//    nat_gateway_id = aws_nat_gateway.nat.id
//  }
//
//  tags = {
//    CreatedBy                                   = local.CreatedBy
//    MangedBy                                    = local.ManagedBy
//    Environment                                 = var.environment
//    Tier                                        = local.Private
//  }
//}
//
//resource "aws_route_table_association" "private" {
//  count           = length(aws_subnet.public)
//  subnet_id       = aws_subnet.private[count.index].id
//  route_table_id  = aws_route_table.private.id
//}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.1.0"

  name                 = "terraform-${var.environment}-vpc"
  cidr                 = var.vpc_cidr_block
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = var.private_cidr_blocks
  public_subnets       = var.public_cidr_blocks
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = local.shared
    "CreatedBy"                                   = local.CreatedBy
    "ManagedBy"                                   = local.ManagedBy
    "Environment"                                 = var.environment
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = local.shared
    "kubernetes.io/role/elb"                      = local.ELB
    "CreatedBy"                                   = local.CreatedBy
    "ManagedBy"                                   = local.ManagedBy
    "Environment"                                 = var.environment
    "Tier"                                        = local.Public
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = local.shared
    "kubernetes.io/role/internal-elb"             = local.ELB
    "CreatedBy"                                   = local.CreatedBy
    "ManagedBy"                                   = local.ManagedBy
    "Environment"                                 = var.environment
    "Tier"                                        = local.Private
  }
}

