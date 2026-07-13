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

# Optional EC2 key-pair name.
#
# When null, instances are created without an SSH key pair because Systems
# Manager Session Manager is the primary administrative access path.
variable "key_name" {
  description = "Optional EC2 key-pair name retained only for temporary SSH fallback."
  type        = string
  default     = null
  nullable    = true
}

variable "iam_instance_profile" {
  description = "IAM instance profile to attach to EC2 instances for SSM access"
  type        = string
  default     = null
}

# Controls whether the transitional public SSH rule is created.
#
# Production-style Session Manager access should leave this disabled.
variable "enable_ssh_access" {
  description = "Whether to create inbound SSH access for web1."
  type        = bool
  default     = false
}

# Optional CIDR used only when enable_ssh_access is true.
variable "ssh_allowed_cidr" {
  description = "CIDR permitted to reach web1 on port 22 when SSH fallback is enabled."
  type        = string
  default     = null
  nullable    = true

  validation {
    condition = (
      var.enable_ssh_access == false ||
      var.ssh_allowed_cidr != null
    )
    error_message = "ssh_allowed_cidr must be supplied when enable_ssh_access is true."
  }
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

# Static private IP used by NGINX to route traffic to web2
variable "web2_private_ip" {
  description = "Static private IP assigned to the web2 application server"
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