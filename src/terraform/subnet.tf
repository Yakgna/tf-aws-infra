data "aws_availability_zones" "available" {
  state = "available"
}

# Public subnets in 3 AZs
resource "aws_subnet" "public_a" {
  depends_on = [
    aws_vpc.csye6225_vpc,
  ]
  vpc_id                  = aws_vpc.csye6225_vpc.id
  cidr_block              = var.cidr_pub_a
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "public-a"
  }
}

resource "aws_subnet" "public_b" {
  depends_on = [
    aws_vpc.csye6225_vpc,
  ]
  vpc_id                  = aws_vpc.csye6225_vpc.id
  cidr_block              = var.cidr_pub_b
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "public-b"
  }
}

resource "aws_subnet" "public_c" {
  depends_on = [
    aws_vpc.csye6225_vpc,
  ]
  vpc_id                  = aws_vpc.csye6225_vpc.id
  cidr_block              = var.cidr_pub_c
  availability_zone       = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = true
  tags = {
    Name = "public-c"
  }
}

# Private subnets in 3 AZs
resource "aws_subnet" "private_a" {
  depends_on = [
    aws_vpc.csye6225_vpc,
  ]
  vpc_id            = aws_vpc.csye6225_vpc.id
  cidr_block        = var.cidr_priv_a
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "private-a"
  }
}

resource "aws_subnet" "private_b" {
  depends_on = [
    aws_vpc.csye6225_vpc,
  ]
  vpc_id            = aws_vpc.csye6225_vpc.id
  cidr_block        = var.cidr_priv_b
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "private-b"
  }
}

resource "aws_subnet" "private_c" {
  depends_on = [
    aws_vpc.csye6225_vpc,
  ]
  vpc_id            = aws_vpc.csye6225_vpc.id
  cidr_block        = var.cidr_priv_c
  availability_zone = data.aws_availability_zones.available.names[2]
  tags = {
    Name = "private-c"
  }
}