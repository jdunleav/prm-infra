#https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/

module "network" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.environment}-network"
  cidr = "10.0.0.0/16"

  azs             = ["${data.aws_availability_zones.azs.names}"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  public_subnet_tags = {
    Name = "${var.environment}-public-subnet"
  }

  private_subnet_tags = {
    Name = "${var.environment}-private-subnet"
  }

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment = "${var.environment}"
    Component   = "network"
  }
}