# Security group for the dedicated monitoring server
resource "aws_security_group" "monitoring_sg" {
  name        = "${var.project_name}-monitoring-sg"
  description = "Allow Prometheus and Grafana access for monitoring"
  vpc_id      = var.vpc_id

  # Allow Prometheus UI access from web1/bastion
  ingress {
    description     = "Prometheus UI from web1 bastion"
    from_port       = 9090
    to_port         = 9090
    protocol        = "tcp"
    security_groups = [var.web1_security_group_id]
  }

  # Allow Grafana UI access from web1/bastion
  ingress {
    description     = "Grafana UI from web1 bastion"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [var.web1_security_group_id]
  }

  # Allow outbound traffic so monitoring server can install packages and scrape targets
  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-monitoring-sg"
    Role = "monitoring"
  })
}

# Dedicated private EC2 host for the centralized monitoring and
# observability tool.
#
# Terraform owns the infrastructure lifecycle of this instance:
# AMI selection, instance sizing, subnet placement, IAM attachment,
# security-group association, and tagging.
#
# Prometheus, Node Exporter, Grafana, and their runtime configuration
# are installed and managed separately through reusable Ansible roles.
resource "aws_instance" "monitoring" {
  ami                         = var.aws_ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  iam_instance_profile        = var.iam_instance_profile
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [aws_security_group.monitoring_sg.id]
  associate_public_ip_address = false

  # There is intentionally no user_data configuration.
  # Charlotte_2026 orchestrates runtime configuration with Ansible after
  # Terraform provisions the monitoring instance.

  tags = merge(var.tags, {
    Name = "${var.project_name}-monitoring"
    Role = "monitoring"
  })
}
