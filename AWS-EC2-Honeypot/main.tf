
# -------------------------
# VPC
# -------------------------
resource "aws_vpc" "Honeypot" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Honeypot"
  }
}

# -------------------------
# Subnets
# -------------------------
resource "aws_subnet" "PublicSubnet" {
  vpc_id                  = aws_vpc.Honeypot.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet"
  }
}

# -------------------------
# Internet Gateway
# -------------------------
resource "aws_internet_gateway" "Honeypot-IGW" {
  vpc_id = aws_vpc.Honeypot.id

  tags = {
    Name = "Honeypot-IGW"
  }
}


# -------------------------
# Route Tables
# -------------------------

# Public Route Table
resource "aws_route_table" "PublicRTB" {
  vpc_id = aws_vpc.Honeypot.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Honeypot-IGW.id
  }

  tags = {
    Name = "PublicRTB"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.PublicSubnet.id
  route_table_id = aws_route_table.PublicRTB.id
}


# -------------------------
# Security Groups
# -------------------------

# Honeypot SG (SSH from your IP)
resource "aws_security_group" "Honeypot_sg" {
  name        = "Honeypot-sg"
  description = "Expose SSH and RDP access to Honeypot-EC2"
  vpc_id      = aws_vpc.Honeypot.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # <-- Allow from internet
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # <-- Allow from internet
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Honeypot-sg"
  }
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
# Key Pair
# -------------------------
resource "aws_key_pair" "ec2_key" {
  key_name   = "dev-at-key"
  public_key = file(var.public_key_path) # <-- adjust to your pubkey path
}

# -------------------------
# Hoenypot Host (Public Subnet)
# -------------------------
resource "aws_instance" "honeypot" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.PublicSubnet.id
  associate_public_ip_address = true
  user_data     = file("userdata.sh")
  key_name      = aws_key_pair.ec2_key.key_name
  vpc_security_group_ids = [aws_security_group.Honeypot_sg.id]

  tags = {
    Name = "honeypot-host"
  }
}