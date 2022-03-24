provider "aws" {
  region = "ap-south-1"
}

# VPC

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_ip
  tags = {
    Name = "Terraform VPC"
  }
}

# PUBLIC SUBNET 

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.pub_ip
  tags = {
    Name = "Public Subnet"
  }
}

# PRIVATE SUBNET

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.prv_ip
  tags = {
    Name = "Private Subnet"
  }

}

# INETERNET GATEWAY

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "My Igw"
  }

}

# ROUTE TABLE 

resource "aws_route_table" "my_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "My Route Table"
  }

}


# ROUTE TABLE ASSOCIATION

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.my_rt.id
}

# Security Group 

resource "aws_security_group" "my_sg" {
  name        = "allow_tls"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "http from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "Terraform Security group"
  }

}

# EC2 INSTANCE 
resource "aws_instance" "myec2" {
  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id = aws_subnet.public_subnet.id
  associate_public_ip_address = "true"
  security_groups = ["${aws_security_group.my_sg.id}"]
  key_name        = var.key_name
  availability_zone = "ap-south-1b"

  tags = {

   Name = "Terraform-Server"

 }
}

