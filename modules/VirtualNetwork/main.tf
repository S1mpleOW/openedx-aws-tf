resource "aws_vpc" "main" {
  cidr_block = var.virtual_network_address_space
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(var.default_tags, {
    created-date = "2024-05-30"
    Name = format("OpenEdx-vpc-%s", var.stage_name)
  })
}

# Subnets
resource "aws_subnet" "public_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_public_address_prefixes_1
  availability_zone = format("%s%s", var.region, "a")

  tags = merge(var.default_tags, {
    created-date = "2024-05-30"
    Name = format("subnet-public-%s-1", var.stage_name)
  })
}

resource "aws_subnet" "public_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_public_address_prefixes_2
  availability_zone = format("%s%s", var.region, "b")

  tags = merge(var.default_tags, {
    created-date = "2024-05-30"
    Name = format("subnet-public-%s-2", var.stage_name)
  })
}

resource "aws_subnet" "public_3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_public_address_prefixes_3
  availability_zone = format("%s%s", var.region, "c")

  tags = merge(var.default_tags, {
    created-date = "2024-05-30"
    Name = format("subnet-public-%s-3", var.stage_name)
  })
}

# Internet Gateway
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.default_tags, {
    Name         = format("igw-main-%s", var.stage_name)
    created-date = "2024-05-30"
  })
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  // redirects all outbound traffic through an internet gw
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = merge(var.default_tags, {
    created-date = "2024-05-30"
  })
}

# Route Table Association
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_3" {
  subnet_id      = aws_subnet.public_3.id
  route_table_id = aws_route_table.public.id
}
