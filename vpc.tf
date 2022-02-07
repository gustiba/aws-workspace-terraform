#1. VPC
resource "aws_vpc" "vpc-workspace" {
  cidr_block = "10.10.0.0/16"

  tags = {
      Name = "vpc-workspace"
  }
}

#2. SUBNET
resource "aws_subnet" "pub-subnet-workspace" {
  vpc_id            = aws_vpc.vpc-workspace.id
  availability_zone = "ap-southeast-1a"
  cidr_block        = "10.10.0.0/24"

  tags = {
      Name = "pub-subnet-workspace"
  }
}

resource "aws_subnet" "priv-subnet-workspace1" {
  vpc_id            = aws_vpc.vpc-workspace.id
  availability_zone = "ap-southeast-1a"
  cidr_block        = "10.10.1.0/24"

    tags = {
      Name = "priv-subnet-workspace1"
  }
}

resource "aws_subnet" "priv-subnet-workspace2" {
  vpc_id            = aws_vpc.vpc-workspace.id
  availability_zone = "ap-southeast-1b"
  cidr_block        = "10.10.2.0/24"

  tags = {
      Name = "priv-subnet-workspace2"
  }
}

#3. CREATE INTERNET GATEWAY
resource "aws_internet_gateway" "igw-workspace" {
  vpc_id = aws_vpc.vpc-workspace.id

  tags = {
    Name = "igw-workspace"
  }
}

#4. CREATE NAT GATEWAY
resource "aws_eip" "eip-nat-workspace" {
  vpc      = true
}

resource "aws_nat_gateway" "nat-workspace" {
  allocation_id = aws_eip.eip-workspace.id
  subnet_id     = aws_subnet.pub-subnet-workspace.id

  tags = {
    Name = "nat-workspace"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw-workspace]
}

#5. CREATE ROUTE TABLE AND ASSOC

resource "aws_route_table" "rt-public-workspace" {
  vpc_id = aws_vpc.vpc-workspace.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-workspace.id
  }

  tags = {
    Name = "rt-public-workspace"
  }
}

resource "aws_route_table_association" "subnet-assoc-public-a" {
  subnet_id      = aws_subnet.pub-subnet-workspace.id
  route_table_id = aws_route_table.rt-public-workspace.id
}

resource "aws_route_table" "rt-private-workspace" {
  vpc_id = aws_vpc.vpc-workspace.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-workspace.id
  }

  tags = {
    Name = "rt-private-workspace"
  }
}

resource "aws_route_table_association" "subnet-assoc-priv-a" {
  subnet_id      = aws_subnet.priv-subnet-workspace1.id
  route_table_id = aws_route_table.rt-private-workspace.id
}

resource "aws_route_table_association" "subnet-assoc-priv-b" {
  subnet_id      = aws_subnet.priv-subnet-workspace2.id
  route_table_id = aws_route_table.rt-private-workspace.id
}