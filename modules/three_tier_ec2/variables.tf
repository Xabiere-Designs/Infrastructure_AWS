# Project name used as a prefix for AWS resource names and tags
variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
}

# AMI used to launch EC2 instances
variable "aws_ami" {
  description = "AMI ID for EC2 instances"
  type        = string
}

# EC2 instance size
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

# Existing AWS key pair for SSH access
variable "key_name" {
  description = "Existing EC2 key pair name"
  type        = string
}

# Public IP allowed to SSH into web1
variable "my_ip_cidr" {
  description = "Your public IP in CIDR notation for SSH access"
  type        = string
}

# VPC created by the VPC module
variable "vpc_id" {
  description = "ID of the VPC to deploy resources in"
  type        = string
}

# Public subnet where the NGINX/bastion host will reside
variable "public_subnet_id" {
  description = "ID of the public subnet for the web server"
  type        = string
}

# Private subnet where the application server will reside
variable "private_subnet_id" {
  description = "ID of the private subnet for the application server"
  type        = string
}

# Startup script executed during web1 provisioning
variable "web1_user_data" {
  description = "User data script executed during web1 instance startup"
  type        = string
  default     = ""
}

# Startup script executed during web2 provisioning
variable "web2_user_data" {
  description = "User data script executed during web2 instance startup"
  type        = string
  default     = ""
}