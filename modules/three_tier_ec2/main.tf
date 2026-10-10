# Security group for the public NGINX reverse proxy (web1).
#
# All rules are managed as standalone aws_vpc_security_group_*_rule resources.
# Do not add inline ingress/egress blocks here: inline and standalone rules on
# the same SG overwrite each other on every apply (see NM-002).
resource "aws_security_group" "web1_sg" {
  name        = "${var.project_name}-web1-sg"
  description = "NGINX reverse proxy - rules managed as standalone resources"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-web1-sg"
  }
}

# Public HTTP into NGINX. Moves behind the ALB in a later migration.
resource "aws_vpc_security_group_ingress_rule" "web1_http" {
  for_each = toset(var.web1_http_ingress_cidrs)

  security_group_id = aws_security_group.web1_sg.id
  description       = "HTTP to NGINX"
  ip_protocol       = "tcp"
  from_port         = var.http_port
  to_port           = var.http_port
  cidr_ipv4         = each.value
}

# Package installs, AWS APIs (incl. SSM), and private app traffic.
resource "aws_vpc_security_group_egress_rule" "web1_all" {
  security_group_id = aws_security_group.web1_sg.id
  description       = "Allow outbound traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = var.egress_cidr_ipv4
}

# Security group for the private application server (web2).
#
# Same rule as web1: standalone rules only, no inline blocks.
resource "aws_security_group" "web2_sg" {
  name        = "${var.project_name}-web2-sg"
  description = "Private app server - rules managed as standalone resources"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-web2-sg"
  }
}

# NGINX on web1 forwards application traffic to web2.
resource "aws_vpc_security_group_ingress_rule" "web2_app_from_web1" {
  security_group_id            = aws_security_group.web2_sg.id
  description                  = "App traffic from web1 NGINX"
  ip_protocol                  = "tcp"
  from_port                    = var.app_port
  to_port                      = var.app_port
  referenced_security_group_id = aws_security_group.web1_sg.id
}

# ALB forwards directly to web2 while the NGINX path stays live.
resource "aws_vpc_security_group_ingress_rule" "web2_app_from_alb" {
  security_group_id            = aws_security_group.web2_sg.id
  description                  = "App traffic from ALB"
  ip_protocol                  = "tcp"
  from_port                    = var.app_port
  to_port                      = var.app_port
  referenced_security_group_id = var.alb_security_group_id
}

# Blackbox HTTP probe from the monitoring host.
resource "aws_vpc_security_group_ingress_rule" "web2_app_from_monitoring" {
  security_group_id            = aws_security_group.web2_sg.id
  description                  = "Blackbox probe from monitoring"
  ip_protocol                  = "tcp"
  from_port                    = var.app_port
  to_port                      = var.app_port
  referenced_security_group_id = var.monitoring_security_group_id
}

# node_exporter scrape from the monitoring host.
resource "aws_vpc_security_group_ingress_rule" "web2_node_exporter_from_monitoring" {
  security_group_id            = aws_security_group.web2_sg.id
  description                  = "node_exporter scrape from monitoring"
  ip_protocol                  = "tcp"
  from_port                    = var.node_exporter_port
  to_port                      = var.node_exporter_port
  referenced_security_group_id = var.monitoring_security_group_id
}

# Package repos, registries, AWS APIs (incl. SSM), and RDS.
resource "aws_vpc_security_group_egress_rule" "web2_all" {
  security_group_id = aws_security_group.web2_sg.id
  description       = "Allow outbound traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = var.egress_cidr_ipv4
}

# Public NGINX reverse proxy. Administered via SSM Session Manager only.
resource "aws_instance" "web1" {
  ami                         = var.aws_ami
  instance_type               = var.instance_type
  iam_instance_profile        = var.iam_instance_profile
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.web1_sg.id]
  associate_public_ip_address = true

  user_data                   = var.web1_user_data
  user_data_replace_on_change = false

  tags = {
    Name = "${var.project_name}-web1-nginx"
  }
}

# Private application server. Static private IP because the NGINX bootstrap
# config points at it; the ALB/target-group design will remove that dependency.
resource "aws_instance" "web2" {
  ami                         = var.aws_ami
  instance_type               = var.instance_type
  iam_instance_profile        = coalesce(var.web2_iam_instance_profile, var.iam_instance_profile)
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
