# terraform/eks-cluster.tf
resource "aws_eks_cluster" "devops_cluster" {
  name     = "devops-portfolio-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.28"

  vpc_config {
    subnet_ids = aws_subnet.public[*].id
  }

  tags = {
    Name = "devops-portfolio-cluster"
  }
}
