# VPC
resource "aws_vpc" "main" { 
  cidr_block = "10.0.0.0/16" 
  enable_dns_support = true 
  enable_dns_hostnames = true 
  
  tags = { 
    Name = "main-vpc" 
  } 
}

# Subnet 
resource "aws_subnet" "main" { 
  vpc_id = aws_vpc.main.id 
  cidr_block = "10.0.1.0/24" 
  availability_zone = "ap-southeast-3a" 
  tags = { 
    Name = "main-subnet" 
  } 
} 

# Route Table 
resource "aws_route_table" "main" { 
  vpc_id = aws_vpc.main.id 
  route { 
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.main.id 
  } 
  tags = { 
    Name = "main-route-table" 
  } 
}

# Internet Gateway 
resource "aws_internet_gateway" "main" { 
  vpc_id = aws_vpc.main.id

  tags = { 
    Name = "main-igw" 
  } 
}

# Route Table Association
resource "aws_route_table_association" "main" {
  subnet_id = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

# Control Node Ansible Security Group
resource "aws_security_group" "control_node_sg" {
  name        = "control-node-sg"
  description = "Allow SSH and HTTP for Control Node"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Using Public IP from VPC
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Using Public IP from VPC
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "control-node-sg"
  }
}

# Web Server Security Group
resource "aws_security_group" "web_server_sg" {
  name        = "web-server-sg"
  description = "Allow SSH and HTTP for Web Server"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Using Public IP from VPC
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-server-sg"
  }
}
