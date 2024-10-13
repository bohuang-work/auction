resource "aws_vpc" "fastapi_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "fastapi_vpc"
  }
}

resource "aws_subnet" "fastapi_vpc_subnet" {
  vpc_id                  = aws_vpc.fastapi_vpc.id
  cidr_block              = "10.123.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "fastapi_vpc_subnet"
  }
}

resource "aws_internet_gateway" "fastapi_internet_gateway" {
  vpc_id = aws_vpc.fastapi_vpc.id

  tags = {
    Name = "fastapi_internet_gateway"
  }
}

resource "aws_route_table" "fastapi_route_table" {
  vpc_id = aws_vpc.fastapi_vpc.id

  tags = {
    Name = "fastapi_route_table"
  }
}

resource "aws_route" "fastapi_route" {
  route_table_id         = aws_route_table.fastapi_route_table.id
  destination_cidr_block = "0.0.0.0/0" # all traffic will hit this internet gateway
  gateway_id             = aws_internet_gateway.fastapi_internet_gateway.id
}

resource "aws_route_table_association" "fastapi_route_table_association" {
  subnet_id      = aws_subnet.fastapi_vpc_subnet.id
  route_table_id = aws_route_table.fastapi_route_table.id
}

resource "aws_security_group" "fastapi_security_group" {
  name        = "fastapi_security_group"
  description = "Allow inbound traffic to the FastAPI server"
  vpc_id      = aws_vpc.fastapi_vpc.id

  # Allow inbound SSH traffic on port 22
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allows access from anywhere (use with caution)
  }

  # Allow inbound HTTP traffic on port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allows access from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "fastapi_key_pair" {
  key_name   = "fastapi_key_pair"
  public_key = file("~/.ssh/id_rsa.pub")
}


resource "aws_instance" "fastapi_instance" {
  ami                    = data.aws_ami.fastapi_ami.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.fastapi_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.fastapi_security_group.id]
  subnet_id              = aws_subnet.fastapi_vpc_subnet.id
  user_data              = file("userdata.tpl")

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "fastapi_instance"
  }
}
