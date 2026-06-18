output "monitoring_instance_id" {
  description = "ID of the monitoring EC2 instance"
  value       = aws_instance.monitoring.id
}

output "monitoring_private_ip" {
  description = "Private IP address of the monitoring EC2 instance"
  value       = aws_instance.monitoring.private_ip
}

output "monitoring_security_group_id" {
  description = "Security group ID for the monitoring server"
  value       = aws_security_group.monitoring_sg.id
}