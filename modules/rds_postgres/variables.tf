variable "project_name" {
  description = "Project name used for naming RDS resources."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the RDS instance will be created."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs used by the RDS subnet group."
  type        = list(string)
}

variable "app_security_group_id" {
  description = "Security group ID for the application tier allowed to connect to PostgreSQL."
  type        = string
}

variable "db_name" {
  description = "Initial PostgreSQL database name."
  type        = string
  default     = "charlottedb"
}

variable "db_username" {
  description = "Master username for PostgreSQL."
  type        = string
}

variable "db_password" {
  description = "Master password for PostgreSQL. This should be supplied from Secrets Manager by the consuming environment."
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated RDS storage in GB."
  type        = number
  default     = 20
}

variable "engine_version" {
  description = "PostgreSQL engine version used when the consuming environment does not explicitly select one."
  type        = string
  default     = "<SUPPORTED_16_X_VERSION>"
}

variable "skip_final_snapshot" {
  description = "Whether to skip final snapshot on destroy. True is acceptable for lab/dev environments."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common resource tags."
  type        = map(string)
  default     = {}
}
