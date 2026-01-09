terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

module "vpc" {
  source = "../../modules/vpc"

  vpc_name             = "my-vpc-${var.environment}"
  vpc_cidr             = "10.0.0.0/16"
  availability_zones   = ["${var.aws_region}a", "${var.aws_region}b"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true  # Set to false for high availability (one NAT per AZ)

  tags = {
    Environment = var.environment
    Project     = "terraform-learning"
    ManagedBy   = "terraform"
    Owner       = "DevOps Team"
  }
}

# Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}

output "nat_gateway_ips" {
  description = "Public IPs of NAT Gateways"
  value       = module.vpc.nat_gateway_public_ips
}

output "web_security_group_id" {
  description = "ID of the web security group"
  value       = module.vpc.web_security_group_id
}

output "app_security_group_id" {
  description = "ID of the app security group"
  value       = module.vpc.app_security_group_id
}

output "database_security_group_id" {
  description = "ID of the database security group"
  value       = module.vpc.database_security_group_id
}