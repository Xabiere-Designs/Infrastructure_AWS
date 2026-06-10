output "web1_public_ip" {
  value = aws_instance.web1.public_ip
}

output "web1_public_dns" {
  value = aws_instance.web1.public_dns
}

output "web1_private_ip" {
  value = aws_instance.web1.private_ip
}

output "web2_private_ip" {
  value = aws_instance.web2.private_ip
}

output "web1_security_group_id" {
  value = aws_security_group.web1_sg.id
}

output "web2_security_group_id" {
  value = aws_security_group.web2_sg.id
}