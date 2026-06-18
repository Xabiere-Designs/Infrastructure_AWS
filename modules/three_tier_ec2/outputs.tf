# Public IP for web1, used for browser/DNS access
output "web1_public_ip" {
  description = "Public IP address of the web1 NGINX/bastion server"
  value       = aws_instance.web1.public_ip
}

# Public DNS for web1, useful for SSH and quick testing
output "web1_public_dns" {
  description = "Public DNS name of the web1 NGINX/bastion server"
  value       = aws_instance.web1.public_dns
}

# Private IP for web1 inside the VPC
output "web1_private_ip" {
  description = "Private IP address of the web1 NGINX/bastion server"
  value       = aws_instance.web1.private_ip
}

# Private IP for web2 inside the VPC
output "web2_private_ip" {
  description = "Private IP address of the web2 application server"
  value       = aws_instance.web2.private_ip
}

# Security group ID for web1
output "web1_security_group_id" {
  description = "Security group ID attached to web1"
  value       = aws_security_group.web1_sg.id
}

# Security group ID for web2
output "web2_security_group_id" {
  description = "Security group ID attached to web2"
  value       = aws_security_group.web2_sg.id
}

# Security group ID for monitoring server, used to allow access from web1/bastion
output "web1_security_group_id" {
  description = "Security group ID for web1 bastion server"
  value       = aws_security_group.web1_sg.id
}

# Security group ID for monitoring server, used to allow access from web1/bastion
output "web2_security_group_id" {
  description = "Security group ID for web2 application server"
  value       = aws_security_group.web2_sg.id
}