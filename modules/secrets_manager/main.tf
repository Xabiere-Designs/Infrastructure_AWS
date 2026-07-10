resource "aws_secretsmanager_secret" "this" {
  for_each = toset(var.secret_names)

  name        = "${var.name_prefix}/${each.value}"
  description = "Secret placeholder for ${each.value}. Secret value should be managed outside Terraform state."

  tags = {
    Name = "${var.name_prefix}-${each.value}"
  }
}