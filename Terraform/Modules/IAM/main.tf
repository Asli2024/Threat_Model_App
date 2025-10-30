resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each   = toset(var.managed_policy_arns)
  role       = aws_iam_role.this.name
  policy_arn = each.value
}

resource "aws_iam_policy" "custom" {
  count  = var.create_custom_policy ? 1 : 0
  name   = var.custom_policy_name
  policy = var.custom_policy_document
}

resource "aws_iam_role_policy_attachment" "custom_policy_attachment" {
  count      = var.create_custom_policy ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.custom[0].arn
}
