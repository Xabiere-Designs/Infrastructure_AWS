variable "name_prefix" {
  description = "Name prefix for Secrets Manager resources."
  type        = string
}

variable "secret_names" {
  description = "List of secret names to create as metadata shells. Values should be populated outside Terraform."
  type        = list(string)
}