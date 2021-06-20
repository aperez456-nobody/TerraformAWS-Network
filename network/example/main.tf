provider "aws" {
  region = local.region
}

module "example_vpc" {
  source = "../module"
  region = local.region
  environment = var.environment
}

locals {
  region = var.region
}