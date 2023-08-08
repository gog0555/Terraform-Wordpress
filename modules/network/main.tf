resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.env}-${var.name}-vpc"
  }
}


resource "aws_subnet" "publicsubnet" {
  vpc_id     = aws_vpc.vpc.id
  map_public_ip_on_launch = true

  for_each = var.subnets.public_subnets

  cidr_block = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "${var.env}-${var.name}-${each.value.name}"
  }
}

resource "aws_subnet" "privatesubnet" {
  vpc_id     = aws_vpc.vpc.id

  for_each = var.subnets.private_subnets

  cidr_block = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "${var.env}-${var.name}-${each.value.name}"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-${var.name}-igw"
  }
}


resource "aws_route_table" "public" {
  vpc_id   = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-${var.name}-public-rtb"
  }
}


resource "aws_route_table" "private" {
  vpc_id   = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-${var.name}-private-rtb"
  }
}


resource "aws_route" "igw" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}


resource "aws_route_table_association" "public" {
  for_each = var.subnets.public_subnets
  subnet_id      = aws_subnet.publicsubnet[each.key].id
  route_table_id = aws_route_table.public.id
}
