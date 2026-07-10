output "endpoint_ids" {
  description = "Created VPC endpoint IDs."
  value       = { for k, v in aws_vpc_endpoint.interface_endpoints : k => v.id }
}

output "security_group_id" {
  description = "Security group used by the VPC interface endpoints."
  value       = aws_security_group.vpc_endpoints.id
}
