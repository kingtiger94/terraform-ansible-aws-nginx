#---------------------------------------------------------------------
# AVG Terrafotm
#
# Build Web server
#---------------------------------------------------------------------

#===================
# make AWS resources
#===================

## Create VPC
resource "aws_vpc" "AVG_Ubuntu_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = var.name_tag
  }
}

## Create internet_gateway
resource "aws_internet_gateway" "AVG_Ubuntu_IG" {
  vpc_id = aws_vpc.AVG_Ubuntu_vpc.id

  tags = {
    Name = var.name_tag
  }
}

## Create LAN
resource "aws_route_table" "AVG_Ubuntu_LAN" {
  vpc_id = aws_vpc.AVG_Ubuntu_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.AVG_Ubuntu_IG.id
  }

  tags = {
    Name = var.name_tag
  }
}

## Create Subnet
resource "aws_subnet" "AVG_Ubuntu_SN" {
  vpc_id                  = aws_vpc.AVG_Ubuntu_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = var.name_tag
  }
}

## Create route table association
resource "aws_route_table_association" "AVG_Ubuntu_association" {
  subnet_id      = aws_subnet.AVG_Ubuntu_SN.id
  route_table_id = aws_route_table.AVG_Ubuntu_LAN.id
}

## Create security group
resource "aws_security_group" "AVG_Ubuntu_SG" {
  name        = "AVG_Ubuntu_SG"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.AVG_Ubuntu_vpc.id

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
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.name_tag
  }
}

## Create ec2 instance
resource "aws_instance" "AVG_Ubuntu" {
  ami                    = var.instance_OS
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.AVG_Ubuntu_SN.id
  vpc_security_group_ids = [aws_security_group.AVG_Ubuntu_SG.id]
  key_name               = var.instance_key_name

  tags = {
    Name = var.name_tag
  }
  # Check instance connection
  provisioner "remote-exec" {
    inline = ["sudo apt install -y python3"]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.ssh_key_private)
      host        = self.public_ip
    }
  }
}

## make s3 to save server state
resource "aws_s3_bucket" "AVG_Ubuntu_bucket" {
  bucket = "avg-server-state"
  acl    = "private"

  tags = {
    Name        = var.name_tag
    Environment = "Dev"
  }
}

#=======================
# Start ansible playbook
#=======================

## make playbook
resource "null_resource" "AVG_Ubuntu" {
  triggers = {
    instance_ips = join(", ", aws_instance.AVG_Ubuntu[*].public_ip)
  }
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i '${join(", ", aws_instance.AVG_Ubuntu[*].public_ip)}', --private-key ${var.ssh_key_private} ${var.playbook_path}"
  }
}
