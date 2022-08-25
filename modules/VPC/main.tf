#VPC Resource
resource "aws_vpc" "akVPC" {
  cidr_block           = var.vpcCidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.name}-Vpc"
  }
}
#Public Subnets
resource "aws_subnet" "publicSubnet" {
  vpc_id = aws_vpc.akVPC.id
  count = length(var.publicSubCidr)
  cidr_block = element(var.publicSubCidr, count.index)
  availability_zone = element(var.availabiltyZone, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.name}-PublicSubnet-${count.index+1}"
  }
}
#Private Subnet
resource "aws_subnet" "privateSubnet" {
  vpc_id = aws_vpc.akVPC.id
  count = length(var.privateSubCidr)
  cidr_block = element(var.privateSubCidr, count.index)
  availability_zone = element(var.availabiltyZone, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.name}-PrivateSubnet-${count.index+1}"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.akVPC.id
  tags = {
    "Name" = "${var.name}-IGW"
  }
}
#Nat GateWay
resource "aws_nat_gateway" "natGateway" {
  count = var.create_nat ? 1 : 0
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.publicSubnet.0.id
  tags = {
    Name = "${var.name}-NatGW"
  }
}
#Elastic IP
resource "aws_eip" "nat_eip" {
  vpc = true
  depends_on = [aws_internet_gateway.IGW]
  tags = {
    Name = "${var.name}-NatEIP"
  }
}
# #Public Route Table
resource "aws_route_table" "PubRT" {
  vpc_id = aws_vpc.akVPC.id
  tags = {
    "Name" = "${var.name}-PubRT"
  }
}
resource "aws_route" "PubNatGWRoute" {
  route_table_id = aws_route_table.PubRT.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.IGW.id
}
#Private Route Table
resource "aws_route_table" "PrivateRT" {
  vpc_id = aws_vpc.akVPC.id
  tags = {
    Name = "${var.name}-PrivateRT"
  }
}
resource "aws_route" "PrivateNATRoute" {
  # depends_on = [aws_nat_gateway.natGateway]
  # count = lookup(aws_)
  count = var.create_nat ? 1 : 0
  route_table_id = aws_route_table.PrivateRT.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.natGateway.0.id
  
}
# #Public Route table subnet assoication
resource "aws_route_table_association" "PubRTAssociation" {
  count = length(var.publicSubCidr)
  subnet_id = element(aws_subnet.publicSubnet.*.id, count.index) 
  route_table_id = aws_route_table.PubRT.id
}
#Private Route table subnet assoication
resource "aws_route_table_association" "PrivateRTAssociation" {
  count = length(var.publicSubCidr)
  subnet_id = element(aws_subnet.privateSubnet.*.id, count.index)
  route_table_id = aws_route_table.PrivateRT.id
}
