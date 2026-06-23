variable "project_name" {
  description = "Project name used for naming and tagging monitoring resources"
  type        = string
}

variable "aws_ami" {
  description = "AMI ID used for the monitoring EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for monitoring server"
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "Existing AWS EC2 key pair name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where monitoring server will be deployed"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID where monitoring server will be deployed"
  type        = string
}

variable "web1_security_group_id" {
  description = "Security group ID for web1/bastion access"
  type        = string
}

variable "monitoring_user_data" {
  description = "Startup script for monitoring server"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}