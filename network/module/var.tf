variable "region" {
  type=string
  description = "AWS region"
}

variable "environment" {
  type = string
  description = "The Environment Name that this application will be deployed to."
}

variable "vpc_cidr_block" {
  type = string
  description = "The Cidr block"
  default = "10.0.0.0/16"
}

variable "private_cidr_blocks" {
  type = list(string)
  description = "private list of cidr blocks"
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_cidr_blocks" {
  type = list(string)
  description = "private list of cidr blocks"
  default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}