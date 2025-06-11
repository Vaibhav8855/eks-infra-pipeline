provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr
  azs  = var.azs

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.8.4"
  cluster_name    = var.cluster_name
  cluster_version = "1.28"

  subnet_ids = module.vpc.private_subnets
  vpc_id     = module.vpc.vpc_id

  enable_irsa        = true
  manage_aws_auth    = true

  eks_managed_node_groups = {
    default = {
      desired_capacity = var.node_desired
      max_capacity     = var.node_max
      min_capacity     = var.node_min
      instance_types   = var.node_instance_types
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
