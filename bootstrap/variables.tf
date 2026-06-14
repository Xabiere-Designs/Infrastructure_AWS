variable "region" { type = string }
variable "state_bucket_name" { type = string }
variable "lock_table_name" { type = string }

variable "tags" {
  type    = map(string)
  default = {}
}