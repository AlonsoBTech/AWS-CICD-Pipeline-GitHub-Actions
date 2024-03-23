resource "aws_vpc" "GitHub_test" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Git_VPC"
  }
}

resource "aws_subnet" "Git_Public_Subnet_1" {
  vpc_id                  = aws_vpc.GitHub_test.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ca-central-1a"

  tags = {
    Name = "Git_Public"
  }
}

resource "aws_internet_gateway" "Git_IGW" {
  vpc_id = aws_vpc.GitHub_test.id

  tags = {
    Name = "Git_IGW"
  }
}

resource "aws_route_table" "Git_Public_Route" {
  vpc_id = aws_vpc.GitHub_test.id

  route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.Git_IGW.id
  }

  tags = {
    Name = "Git_Pub_RT"
  }
}

resource "aws_route_table_association" "Git_pub_asso1" {
  subnet_id      = aws_subnet.Git_Public_Subnet_1.id
  route_table_id = aws_route_table.Git_Public_Route.id
}
