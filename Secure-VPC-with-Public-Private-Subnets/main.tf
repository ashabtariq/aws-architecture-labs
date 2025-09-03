provider "aws" {
  region = "us-east-1"
}

# -------------------------
# VPC
# -------------------------
resource "aws_vpc" "SecurityLab" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "SecurityLab"
  }
}

# -------------------------
# Subnets
# -------------------------
resource "aws_subnet" "PublicSubnet" {
  vpc_id                  = aws_vpc.SecurityLab.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet"
  }
}

resource "aws_subnet" "PrivateSubnet" {
  vpc_id                  = aws_vpc.SecurityLab.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "PrivateSubnet"
  }
}

# -------------------------
# Internet Gateway
# -------------------------
resource "aws_internet_gateway" "SecurityLabIGW" {
  vpc_id = aws_vpc.SecurityLab.id

  tags = {
    Name = "SecurityLabIGW"
  }
}

# -------------------------
# Elastic IP for NAT
# -------------------------
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

# -------------------------
# NAT Gateway (Public Subnet)
# -------------------------
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.PublicSubnet.id

  tags = {
    Name = "NAT-Gateway"
  }
}

# -------------------------
# Route Tables
# -------------------------

# Public Route Table
resource "aws_route_table" "PublicRTB" {
  vpc_id = aws_vpc.SecurityLab.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.SecurityLabIGW.id
  }

  tags = {
    Name = "PublicRTB"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.PublicSubnet.id
  route_table_id = aws_route_table.PublicRTB.id
}

# Private Route Table
resource "aws_route_table" "PrivateRTB" {
  vpc_id = aws_vpc.SecurityLab.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "PrivateRTB"
  }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.PrivateSubnet.id
  route_table_id = aws_route_table.PrivateRTB.id
}

# -------------------------
# Security Groups
# -------------------------

# Bastion SG (SSH from your IP)
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow SSH access to bastion host"
  vpc_id      = aws_vpc.SecurityLab.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["YOUR_PUBLIC_IP/32"] # <-- Replace with your IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

# Private EC2 SG (only allow SSH from Bastion SG)
resource "aws_security_group" "private_sg" {
  name        = "private-ec2-sg"
  description = "Allow SSH from bastion only"
  vpc_id      = aws_vpc.SecurityLab.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-ec2-sg"
  }
}

# -------------------------
# Key Pair
# -------------------------
resource "aws_key_pair" "ec2_key" {
  key_name   = "securitylab-key"
  public_key = file("~/.ssh/id_rsa.pub") # <-- adjust to your pubkey path
}

# -------------------------
# AMI Lookup (Ubuntu 20.04 LTS)
# -------------------------
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# -------------------------
# Bastion Host (Public Subnet)
# -------------------------
resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.PublicSubnet.id
  associate_public_ip_address = true
  key_name      = aws_key_pair.ec2_key.key_name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "bastion-host"
  }
}

# -------------------------
# Private EC2 (Private Subnet)
# -------------------------
resource "aws_instance" "private_ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.PrivateSubnet.id
  key_name      = aws_key_pair.ec2_key.key_name
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  tags = {
    Name = "private-ec2"
  }
}
