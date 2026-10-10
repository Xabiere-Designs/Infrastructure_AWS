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

variable "iam_instance_profile" {
  description = "IAM instance profile to attach to EC2 instances for SSM access"
  type        = string
  default     = null
}

variable "web2_iam_instance_profile" {
  description = "Optional dedicated IAM instance profile for web2. Falls back to iam_instance_profile if null."
  type        = string
  default     = null
  nullable    = true
}

# VPC created by the VPC module
variable "vpc_id" {
  description = "ID of the VPC to deploy resources in"
  type        = string
}

# Public subnet where the NGINX host will reside
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

# Security group ID of the Application Load Balancer (created in the root).
# Source for web2 app-port ingress while the NGINX path remains live.
variable "alb_security_group_id" {
  description = "Security group ID of the ALB; ingress source for web2 app traffic."
  type        = string
}

# Security group ID of the monitoring host (created in the root).
# Source for blackbox probes and node_exporter scrapes into web2.
variable "monitoring_security_group_id" {
  description = "Security group ID of the monitoring host; source for probe and scrape ingress."
  type        = string
}

# Port the application listens on (NGINX upstream, ALB target, blackbox probe)
variable "app_port" {
  description = "Port the web2 application listens on"
  type        = number
  default     = 8080
}

# Port NGINX listens on for public HTTP
variable "http_port" {
  description = "HTTP port exposed by NGINX on web1"
  type        = number
  default     = 80
}

# Port node_exporter listens on
variable "node_exporter_port" {
  description = "Port node_exporter listens on for Prometheus scrapes"
  type        = number
  default     = 9100
}

# CIDRs allowed to reach NGINX over HTTP
variable "web1_http_ingress_cidrs" {
  description = "IPv4 CIDRs allowed HTTP access to web1"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Destination CIDR for outbound traffic from both instances
variable "egress_cidr_ipv4" {
  description = "IPv4 CIDR for outbound traffic from web1 and web2"
  type        = string
  default     = "0.0.0.0/0"
}
