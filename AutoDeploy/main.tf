provider "aws" {
}

# ------------------------------
# Generate Key Pair (PemOfCICD.pem)
# ------------------------------
resource "tls_private_key" "PemOfCICD_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "PemOfCICD_key" {
  key_name   = "PemOfCICD"
  public_key = tls_private_key.PemOfCICD_key.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.PemOfCICD_key.private_key_pem
  filename = "${path.module}/PemOfCICD.pem"
}

# Step 1: Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/24"
  tags = {
    Name: "my_vpc"
  }
}

# Step 1.1: Create Public
resource "aws_subnet" "my_public_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/25"
  tags = {
    Name: "my_public_subnet"
  }
  map_public_ip_on_launch = true
}


# Step 1.2: Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name: "my_igw"
  }
}

# Step 1.3: Route Table for Public Subnet
resource "aws_route_table" "my_public_route" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name: "my_public_route"
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.my_public_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.my_public_subnet.id
  route_table_id = aws_route_table.my_public_route.id
}
# Step 2: Security Group for EC2
resource "aws_security_group" "CICD-sec-grp" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name: "CICD-sec-grp"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "Docker_CICD_Ec2" {
  ami           = "ami-04b4f1a9cf54c11d0"  # Update with the latest Ubuntu AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_public_subnet.id
  vpc_security_group_ids = [aws_security_group.CICD-sec-grp.id]
  key_name      = aws_key_pair.PemOfCICD_key.key_name

  tags = {
    Name = "Docker_CICD_Ec2"
  }
}
resource "aws_instance" "Jenkins_CICD_Ec2" {
  ami           = "ami-04b4f1a9cf54c11d0"  # Update with the latest Ubuntu AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_public_subnet.id
  vpc_security_group_ids = [aws_security_group.CICD-sec-grp.id]
  key_name      = aws_key_pair.PemOfCICD_key.key_name

  tags = {
    Name = "Jenkins_CICD_Ec2"
  }
}