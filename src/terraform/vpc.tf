resource "aws_vpc" "csye6225_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.project_name}_${var.vpc_name}"
  }
}