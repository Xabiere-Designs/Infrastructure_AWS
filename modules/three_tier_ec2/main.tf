# Security group for the public-facing NGINX/bastion server
resource "aws_security_group" "web1_sg" {
  name        = "${var.project_name}-web1-sg"
  description = "Allow SSH and HTTP to web1"
  vpc_id      = var.vpc_id

  # Transitional SSH rule.
  #
  # This resource is created only when the consuming environment explicitly
  # enables SSH fallback. Normal Charlotte administration uses Session Manager.
  resource "aws_vpc_security_group_ingress_rule" "web1_ssh" {
    count = var.enable_ssh_access ? 1 : 0

    security_group_id = aws_security_group.web1_sg.id

    description = "Temporary SSH fallback from explicitly approved CIDR"
    ip_protocol = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_ipv4   = var.ssh_allowed_cidr
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
  iam_instance_profile        = var.iam_instance_profile
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
  iam_instance_profile        = var.iam_instance_profile
  subnet_id                   = var.private_subnet_id
  private_ip                  = var.web2_private_ip
  vpc_security_group_ids      = [aws_security_group.web2_sg.id]
  associate_public_ip_address = false
  user_data                   = var.web2_user_data

  tags = {
    Name = "${var.project_name}-web2-app-server"
  }
}
