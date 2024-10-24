data "aws_availability_zones" "available" {
  state = "available"
}

# Define the maximum number of subnets as 3 or the number of available zones
locals {
  azs = length(data.aws_availability_zones.available.names) > 3 ? slice(data.aws_availability_zones.available.names, 0, 3) : data.aws_availability_zones.available.names
}

# Public subnets
resource "aws_subnet" "public" {
  depends_on = [aws_vpc.csye6225_vpc]
  count      = length(local.azs)

  vpc_id                  = aws_vpc.csye6225_vpc.id
  cidr_block              = var.public_cidr_blocks[count.index]
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-${local.azs[count.index]}"
  }
}

# Private subnets
resource "aws_subnet" "private" {
  depends_on = [aws_vpc.csye6225_vpc]
  count      = length(local.azs)

  vpc_id            = aws_vpc.csye6225_vpc.id
  cidr_block        = var.private_cidr_blocks[count.index]
  availability_zone = local.azs[count.index]

  tags = {
    Name = "private-${local.azs[count.index]}"
  }
}
