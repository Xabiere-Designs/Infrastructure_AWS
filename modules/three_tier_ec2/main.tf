# Security group for the public NGINX reverse proxy and temporary bastion host.
#
# Charlotte_2026 currently retains SSH as a transitional fallback while the
# application, RDS, monitoring, and existing Ansible execution path are
# validated. A later dedicated migration will remove port 22 and make
# Systems Manager the primary configuration and administration path.
resource "aws_security_group" "web1_sg" {
  name        = "${var.project_name}-web1-sg"
  description = "Allow HTTP and temporary SSH access to web1"
  vpc_id      = var.vpc_id

  # Temporary administrative access from the approved public CIDR.
  ingress {
    description = "SSH from approved administrator CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  # Public application traffic currently enters through web1 and NGINX.
  # This ingress path will later move behind an Application Load Balancer.
  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allows package installation, AWS API access, and communication with
  # private application resources.
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

# Security group for the private application server.
#
# Only web1 is permitted to reach the application service and temporary SSH
# path. The private application server is not directly exposed to the internet.
resource "aws_security_group" "web2_sg" {
  name        = "${var.project_name}-web2-sg"
  description = "Allow web1 to reach the private application server"
  vpc_id      = var.vpc_id

  # Temporary SSH path from web1 while the bastion-based Ansible transport
  # remains active.
  ingress {
    description     = "SSH from web1"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.web1_sg.id]
  }

  # Allows NGINX on web1 to forward application traffic to web2.
  ingress {
    description     = "Application traffic from web1"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.web1_sg.id]
  }

  # Allows the private application server to reach package repositories,
  # container registries, AWS services, RDS, and other approved destinations.
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

# Public NGINX reverse proxy and temporary bastion EC2 instance.
#
# Terraform provisions the instance and passes the existing NGINX bootstrap
# content. Administrative SSH remains temporary while Session Manager and the
# future ALB-based ingress model are validated as separate migrations.
resource "aws_instance" "web1" {
  ami                         = var.aws_ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  iam_instance_profile        = var.iam_instance_profile
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.web1_sg.id]
  associate_public_ip_address = true

  user_data                   = var.web1_user_data
  user_data_replace_on_change = false

  tags = {
    Name = "${var.project_name}-web1-nginx-bastion"
  }
}

# Private application EC2 instance.
#
# The application host keeps a predictable private IP because the current
# NGINX bootstrap configuration points web1 at this address. A future ALB and
# target-group design will reduce this static-address dependency.
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
  user_data_replace_on_change = false

  tags = {
    Name = "${var.project_name}-web2-app-server"
  }
}