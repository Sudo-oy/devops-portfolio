# terraform/policies.tf
resource "aws_iam_policy" "devops_monitoring_policy" {
  name        = "devops-monitoring-policy"
  description = "Permet à EKS et EC2 de publier logs dans CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_monitoring_policy" {
  role       = aws_iam_role.eks_nodes_role.name
  policy_arn = aws_iam_policy.devops_monitoring_policy.arn
}
