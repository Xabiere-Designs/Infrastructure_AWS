# Security group for the public-facing NGINX/bastion server
resource "aws_security_group" "web1_sg" {
  name        = "${var.project_name}-web1-sg"
  description = "Allow SSH and HTTP to web1"
  vpc_id      = var.vpc_id

  # Allow administrative SSH access from the approved public IP
  ingress {
    description = "SSH from allowed IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  # Allow public HTTP traffic to NGINX
  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow web1 to reach package repos, Docker Hub, and private app tier
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

  # Allow SSH to web2 only through web1/bastion
  ingress {
    description     = "SSH from web1"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.web1_sg.id]
  }

  # Allow NGINX on web1 to proxy traffic to Tomcat on web2
  ingress {
    description     = "Tomcat from web1"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.web1_sg.id]
  }

  # Allow web2 to reach package repos and pull images through NAT
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
  private_ip                  = var.web2_private_ip
  vpc_security_group_ids      = [aws_security_group.web2_sg.id]
  associate_public_ip_address = false
  user_data                   = var.web2_user_data

  tags = {
    Name = "${var.project_name}-web2-app-server"
  }
}