# Security group for the public-facing NGINX/bastion server
resource "aws_security_group" "web1_sg" {
  name        = "${var.project_name}-web1-sg"
  description = "Allow SSH and HTTP to web1"
  vpc_id      = var.vpc_id

  # Allow administrative SSH access
  ingress {
    description = "SSH from allowed IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  # Allow public web traffic
  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound connectivity
  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-web1-sg"
  }
}

# Security group for the private application server
resource "aws_security_group" "web2_sg" {
  name        = "${var.project_name}-web2-sg"
  description = "Allow web1 to reach web2"
  vpc_id      = var.vpc_id

  # Allow SSH only from web1
  ingress {
    description     = "SSH from web1"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.web1_sg.id]
  }

  # Allow Tomcat traffic only from web1
  ingress {
    description     = "Tomcat from web1"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.web1_sg.id]
  }

  # Allow outbound connectivity
  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-web2-sg"
  }
}

# Public EC2 instance hosting NGINX and acting as bastion host
resource "aws_instance" "web1" {
  ami                         = var.aws_ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.web1_sg.id]
  associate_public_ip_address = true
  user_data                   = var.web1_user_data

  tags = {
    Name = "${var.project_name}-web1-nginx-bastion"
  }
}

# Private EC2 instance hosting Docker/Tomcat application
resource "aws_instance" "web2" {
  ami                         = var.aws_ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [aws_security_group.web2_sg.id]
  associate_public_ip_address = false
  user_data                   = var.web2_user_data

  tags = {
    Name = "${var.project_name}-web2-app-server"
  }
}