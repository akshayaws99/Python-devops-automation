# aws_terraform/eks_cluster.tf
resource "aws_eks_cluster" "eks" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.eks_k8s_version

  vpc_config {
    subnet_ids = var.private_subnet_ids
    endpoint_public_access = true
    endpoint_private_access = false
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_AmazonEKSServicePolicy
  ]
}

# EKS cluster logging (optional)
resource "aws_eks_cluster_logging" "cluster_logging" {
  cluster_name = aws_eks_cluster.eks.name

  cluster_logging {
    enabled = true
    types   = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  }
}
