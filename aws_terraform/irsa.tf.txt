# aws_terraform/irsa.tf
# Create OIDC provider for the EKS cluster (required for IRSA)
data "aws_eks_cluster" "eks" {
  name = aws_eks_cluster.eks.name
}

data "aws_eks_cluster_auth" "eks" {
  name = aws_eks_cluster.eks.name
}

resource "aws_iam_openid_connect_provider" "eks_oidc" {
  url = replace(data.aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://", "")
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc_thumbprint.cert_thumbprint]
}

# TLS data source to compute thumbprint
data "tls_certificate" "oidc_thumbprint" {
  url = data.aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

# Example IAM policy for pods that need S3 access
data "aws_iam_policy_document" "irsa_assume_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks_oidc.arn]
    }
    condition {
      test = "StringEquals"
      values = ["system:serviceaccount:${var.irsa_namespace}:${var.irsa_service_account_name}"]
      variable = "${replace(data.aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://", "")}:sub"
    }
  }
}

resource "aws_iam_role" "irsa_role" {
  name = "${var.eks_cluster_name}-${var.irsa_service_account_name}-role"
  assume_role_policy = data.aws_iam_policy_document.irsa_assume_role.json
}

# Attach S3 read/write policy (adjust to least privilege)
resource "aws_iam_policy" "irsa_s3_policy" {
  name = "${var.eks_cluster_name}-irsa-s3-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject","s3:PutObject","s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}",
          "arn:aws:s3:::${var.s3_bucket_name}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "irsa_policy_attach" {
  role       = aws_iam_role.irsa_role.name
  policy_arn = aws_iam_policy.irsa_s3_policy.arn
}
