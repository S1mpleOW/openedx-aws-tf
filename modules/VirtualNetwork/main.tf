resource "aws_vpc" "main" {
  cidr_block = var.virtual_network_address_space
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(var.default_tags, {
    created-date = "2024-05-30"
  })
}

# Subnets
resource "aws_subnet" "application-main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.main_subnet_application_address_prefixes

  tags = merge(var.default_tags, {
    created-date = "2024-05-30"
    Name = format("subnet-application-%s", var.stage_name)
  })
}

resource "aws_subnet" "database-main-1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_data_address_1_prefixes

  tags = merge(var.default_tags, {
    created-date = "2024-05-30"
    Name = format("subnet-database-1-%s", var.stage_name)
  })
}

resource "aws_subnet" "database-main-2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_data_address_2_prefixes

  tags = merge(var.default_tags, {
    created-date = "2024-05-30"
    Name = format("subnet-database-2-%s", var.stage_name)
  })
}

# Internet Gateway
resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.default_tags, {
    created-date = "2024-05-30"
  })
}

# Nat Gateway
resource "aws_eip" "database-eip-1" {
  domain = "vpc"
  tags = merge(var.default_tags, {
    created-date : "2024-05-30"
    Name : format("eip-database-1-%s", var.stage_name)
  })
}

resource "aws_nat_gateway" "database-natgw-1" {
  subnet_id         = aws_subnet.database-main-1.id
  allocation_id     = aws_eip.database-eip-1.id
  connectivity_type = "public"
  tags = merge(var.default_tags, {
    created-date : "2024-05-30"
    Name : format("nat-database-1-%s", var.stage_name)
  })
}

resource "aws_eip" "database-eip-2" {
  domain = "vpc"
  tags = merge(var.default_tags, {
    created-date : "2024-05-30"
    Name : format("eip-database-2-%s", var.stage_name)
  })
}

resource "aws_nat_gateway" "database-natgw-2" {
  subnet_id         = aws_subnet.database-main-2.id
  allocation_id     = aws_eip.database-eip-2.id
  connectivity_type = "public"
  tags = merge(var.default_tags, {
    created-date : "2024-05-30"
    Name : format("nat-database-2-%s", var.stage_name)
  })
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  // redirects all outbound traffic through an internet gw
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }

  tags = merge(var.default_tags, {
    created-date = "2024-05-30"
  })
}

resource "aws_route_table" "private-1" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.database-natgw-1.id
  }
  tags = merge(var.default_tags, {
    created-date : "2024-05-30"
    Name : format("rt-database-%s-nat-1", var.stage_name)
  })
}

resource "aws_route_table" "private-2" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.database-natgw-2.id
  }
  tags = merge(var.default_tags, {
    created-date : "2024-05-30"
    Name : format("rt-database-%s-nat-2", var.stage_name)
  })
}

# Route Table Association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.application-main.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private-1" {
  subnet_id      = aws_subnet.database-main-1.id
  route_table_id = aws_route_table.private-1.id
}

resource "aws_route_table_association" "private-2" {
  subnet_id      = aws_subnet.database-main-2.id
  route_table_id = aws_route_table.private-2.id
}
