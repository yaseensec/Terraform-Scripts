module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "darkrose-${var.infra-env}-vpc"
  cidr = var.vpc-cidr

  azs             = var.azs
  private_subnets = var.private-subnets
  public_subnets  = var.public-subnets
  database_subnets = var.database-subnets

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  enable_vpn_gateway = false
  
  tags = {
    Name        = "darkrose-${var.infra-env}-web"
    Project     = "Darkrose.io"
    Environment = var.infra-env
    ManagedBy   = "terraform"
  }

  private_subnet_tags = {
    Role = "private"
  }

  public_subnet_tags = {
    Role = "public"
  }

  database_subnet_tags = {
    Role = "database"
  }
}