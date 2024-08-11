data "aws_availability_zones" "available" {}

locals {
  name   = var.name
  region = var.region

  vpc_cidr = var.vpc_cidr
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    GithubRepo = "ian-chan-ml/intw-antarticite"
    Owner      = "quanianitis@moneylion.com"
  }
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = local.name
  cidr = local.vpc_cidr

  azs = local.azs

  public_subnets     = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnet_tags = { Usage = "public", "kubernetes.io/role/elb" = 1 }

  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 3)]
  private_subnet_tags = { Usage = "private", "kubernetes.io/role/internal-elb" = 1
    # Tags subnets for Karpenter auto-discovery
  "karpenter.sh/discovery" = "antarticite" }

  database_subnets     = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 6)]
  database_subnet_tags = { Usage = "database" }

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.tags
}
