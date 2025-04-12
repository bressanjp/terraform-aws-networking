# ==================================================
# 🚀 Provider AWS - Definindo a AWS como provedor
# ==================================================
provider "aws" {
  region = "us-east-1"
}

# ==================================================
# 🌐 VPC - Criação da rede principal da infra
# ==================================================
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}

# ==================================================
# 🌍 Internet Gateway - Permite comunicação com a internet
# ==================================================
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main-igw"
  }
}

# ==================================================
# 📡 Pega automaticamente as zonas de disponibilidade
# ==================================================
data "aws_availability_zones" "available" {}

# ==================================================
# 🌐 Subnets Públicas
# ==================================================
resource "aws_subnet" "public_subnets" {
  count = 3
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = cidrsubnet(aws_vpc.main_vpc.cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

# ==================================================
# 🔒 Subnets Privadas
# ==================================================
resource "aws_subnet" "private_subnets" {
  count = 3
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = cidrsubnet(aws_vpc.main_vpc.cidr_block, 8, count.index + 10)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

# ==================================================
# 🌐 Elastic IP para NAT Gateway
# ==================================================
resource "aws_eip" "nat_eip" {
  vpc = true
}

# ==================================================
# 🚪 NAT Gateway
# ==================================================
resource "aws_nat_gateway" "main_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = "main-nat"
  }
}

# ==================================================
# 🧭 Route Table Pública
# ==================================================
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

# ==================================================
# 🔗 Associa subnets públicas à tabela de rotas pública
# ==================================================
resource "aws_route_table_association" "public_rta" {
  count = 3
  subnet_id = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# ==================================================
# 🧭 Route Table Privada
# ==================================================
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main_nat.id
  }

  tags = {
    Name = "private-rt"
  }
}

# ==================================================
# 🔗 Associa subnets privadas à tabela de rotas privada
# ==================================================
resource "aws_route_table_association" "private_rta" {
  count = 3
  subnet_id = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rt.id
}
