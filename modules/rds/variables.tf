variable "name" { type = string }
variable "vpc_id" { type = string }
variable "private_subnet_ids" { type = list(string) }

variable "db_name" { type = string default = "appdb" }
variable "db_username" { type = string default = "appuser" }
variable "db_instance_class" { type = string default = "db.t3.micro" }
variable "engine_version" { type = string default = "15.5" } # postgres example

variable "tags" {
  type    = map(string)
  default = {}
}