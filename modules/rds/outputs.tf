output "db_endpoint" { value = aws_db_instance.this.address }
output "db_port"     { value = aws_db_instance.this.port }
output "db_secret_arn" { value = aws_secretsmanager_secret.db.arn }
output "db_sg_id" { value = aws_security_group.db.id }