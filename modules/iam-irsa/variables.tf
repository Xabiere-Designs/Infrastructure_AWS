variable "name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "service_account_name" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}

variable "oidc_issuer_url" {
  type = string
}

variable "policy_json" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}