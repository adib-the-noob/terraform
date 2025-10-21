# creating the VPC
resource "aws_vpc" "my_vpc_01" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my_vpc"
  }
}

# private subnet
resource "aws_subnet" "private-subnet" {
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.my_vpc_01.id
  availability_zone = "ap-south-1a"
  tags = {
    Name = "private-subnet"
  }
}

# public subnet
resource "aws_subnet" "public-subnet" {
  cidr_block              = "10.0.2.0/24"
  vpc_id                  = aws_vpc.my_vpc_01.id
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

# InternetGateway
resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my_vpc_01.id
  tags = {
    Name = "my-igw"
  }
}

# Route Table
resource "aws_route_table" "my-rt" {
  vpc_id = aws_vpc.my_vpc_01.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
  
  tags = {
    Name = "public-rt"
  }
}

# Public subnet (connecting) => route table
resource "aws_route_table_association" "public-sub" {
  route_table_id = aws_route_table.my-rt.id
  subnet_id      = aws_subnet.public-subnet.id
}