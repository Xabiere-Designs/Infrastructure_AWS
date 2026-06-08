data "aws_iam_openid_connect_provider" "oidc" {
  arn = var.oidc_provider_arn
}

resource "aws_iam_role" "irsa" {

  name = var.name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Federated = var.oidc_provider_arn
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            "${replace(var.oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
          }
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_policy" "policy" {
  name   = "${var.name}-policy"
  policy = var.policy_json
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.irsa.name
  policy_arn = aws_iam_policy.policy.arn
}