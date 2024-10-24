# Public route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.csye6225_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.csye_6225_igw.id
  }
  tags = {
    Name = "public-rt"
  }
}

# Associate public subnets with the public route table
resource "aws_route_table_association" "public" {
  count          = length(local.azs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# Private route table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.csye6225_vpc.id
  tags = {
    Name = "private-rt"
  }
}

# Associate private subnets with the private route table
resource "aws_route_table_association" "private" {
  count          = length(local.azs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt.id
}