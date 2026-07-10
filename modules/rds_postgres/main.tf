# Creates a subnet group so RDS can live only inside private subnets.
# RDS requires a DB subnet group when deploying into a VPC.
resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-rds-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = merge(var.tags, {
    Name = "${var.project_name}-rds-subnet-group"
  })
}

# Security group for PostgreSQL.
# This allows only the application tier security group to connect on port 5432.
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-postgres-sg"
  description = "Allow PostgreSQL access from the application tier"
  vpc_id      = var.vpc_id

  ingress {
    description     = "PostgreSQL from application tier"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.app_security_group_id]
  }

  egress {
    description = "Allow outbound responses"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-rds-postgres-sg"
  })
}

# Managed PostgreSQL database.
# This is the data tier for Charlotte_2026.
resource "aws_db_instance" "this" {
  identifier = "${var.project_name}-postgres"

  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.db_instance_class

  allocated_storage = var.allocated_storage
  storage_type      = "gp3"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  publicly_accessible = false

  # Dev/lab friendly settings.
  # In production, you would normally use deletion protection and final snapshots.
  skip_final_snapshot = var.skip_final_snapshot
  deletion_protection = false

  # Basic safety and maintainability settings.
  backup_retention_period = 1
  auto_minor_version_upgrade = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-postgres"
    Tier = "Data"
  })
}
