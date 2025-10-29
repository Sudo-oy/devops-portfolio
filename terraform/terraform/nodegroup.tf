# terraform/nodegroup.tf
resource "aws_eks_node_group" "devops_nodes" {
  cluster_name    = aws_eks_cluster.devops_cluster.name
  node_group_name = "devops-portfolio-nodes"
  node_role_arn   = aws_iam_role.eks_nodes_role.arn
  subnet_ids      = aws_subnet.public[*].id

  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 4
  }

  instance_types = ["t3.medium"]

  tags = {
    Name = "devops-portfolio-node"
  }
}
