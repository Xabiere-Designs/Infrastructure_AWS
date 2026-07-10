variable "name_prefix" {
  description = "Name prefix for VPC endpoint resources."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where endpoints will be created."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for interface endpoints."
  type        = list(string)
}

variable "vpc_cidr_block" {
  description = "CIDR block allowed to reach the VPC endpoints over HTTPS."
  type        = string
}

variable "region" {
  description = "AWS region."
  type        = string
}
