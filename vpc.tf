locals {
  vpc_name        = "vpc-name"
  vpc_cidr        = "10.10.0.0/16"
  azs             = ["${local.region}a", "${local.region}b"]
  public_subnets  = ["10.10.10.0/24", "10.10.11.0/24"]
  private_subnets = ["10.10.12.0/24", "10.10.13.0/24"]

}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.vpc_name
  cidr = local.vpc_cidr

  azs = local.azs

  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
}