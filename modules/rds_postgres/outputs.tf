output "db_instance_id" {
  description = "RDS instance identifier."
  value       = aws_db_instance.this.id
}

output "db_endpoint" {
  description = "RDS PostgreSQL endpoint address."
  value       = aws_db_instance.this.address
}

output "db_port" {
  description = "RDS PostgreSQL port."
  value       = aws_db_instance.this.port
}

output "db_name" {
  description = "Initial database name."
  value       = aws_db_instance.this.db_name
}

output "rds_security_group_id" {
  description = "RDS security group ID."
  value       = aws_security_group.rds.id
}
