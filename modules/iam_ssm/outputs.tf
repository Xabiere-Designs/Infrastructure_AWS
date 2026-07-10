output "instance_profile_name" {
  description = "IAM instance profile name for EC2 instances managed by SSM."
  value       = aws_iam_instance_profile.ssm_instance_profile.name
}

output "role_name" {
  description = "IAM role name attached to the EC2 instance profile."
  value       = aws_iam_role.ssm_role.name
}
